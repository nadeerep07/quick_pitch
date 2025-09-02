import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/payment_request_cubit.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/action_buttons.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/amount_field.dart' show AmountField;
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/budget_info.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/header.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/payment_request/notes_field.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentRequestForm extends StatefulWidget {
  final PitchModel pitch;
  final Future<void> Function(double amount, String notes) onRequestPayment;

  const PaymentRequestForm({super.key, 
    required this.pitch,
    required this.onRequestPayment,
  });

  @override
  State<PaymentRequestForm> createState() => PaymentRequestFormState();
}

class PaymentRequestFormState extends State<PaymentRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.pitch.budget.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<PaymentRequestCubit>();
    cubit.setLoading(true);

    try {
      final amount = double.parse(_amountController.text);
      final notes = _notesController.text.trim();

      await widget.onRequestPayment(amount, notes);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) cubit.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(res.wp(6)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(res: res, theme: theme),
              SizedBox(height: res.hp(2)),
              BudgetInfo(res: res, pitch: widget.pitch, theme: theme),
              SizedBox(height: res.hp(2)),
              AmountField(res: res, controller: _amountController, theme: theme),
              SizedBox(height: res.hp(2)),
              NotesField(res: res, controller: _notesController, theme: theme),
              SizedBox(height: res.hp(3)),
              BlocBuilder<PaymentRequestCubit, PaymentRequestState>(
                builder: (context, state) {
                  return ActionButtons(
                    res: res,
                    isLoading: state.isLoading,
                    onCancel: () => Navigator.of(context).pop(),
                    onSubmit: () => _handleSubmit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}