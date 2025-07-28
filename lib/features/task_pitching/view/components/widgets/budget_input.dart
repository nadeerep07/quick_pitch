import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class BudgetInput extends StatelessWidget {
  const BudgetInput({
    super.key,
    required TextEditingController budgetController,
    required this.res,
    required this.colorScheme,
    required this.minBudget,
    required this.maxBudget,
  }) : _budgetController = budgetController;

  final TextEditingController _budgetController;
  final Responsive res;
  final ColorScheme colorScheme;
  final double minBudget;
  final double maxBudget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchFormCubit, PitchFormState>(
      builder: (context, formState) {
        return TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: colorScheme.onSurface, fontSize: res.sp(14)),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.attach_money,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: res.wp(5),
            ),
            hintText: formState.paymentType == PaymentType.fixed 
                ? 'Enter total budget' 
                : 'Enter hourly rate',
            hintStyle: TextStyle(fontSize: res.sp(14)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(res.wp(3)),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              vertical: res.hp(2),
              horizontal: res.wp(4),
            ),
            helperText: formState.paymentType == PaymentType.fixed
                ? 'Suggested Range: \$${minBudget.toStringAsFixed(0)} - \$${maxBudget.toStringAsFixed(0)}'
                : 'Example: \$15/hour',
            helperStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: res.sp(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter an amount';
            if (double.tryParse(value) == null) return 'Enter a valid number';
            return null;
          },
        );
      },
    );
  }
}
