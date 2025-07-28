import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/common/success_dialog.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/hours_section.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_budget_section.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_payement_type_section.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_section.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/pitch_task_details.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/time_line_section.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class TaskPitchingScreen extends StatefulWidget {
  final TaskPostModel taskData;

  const TaskPitchingScreen({super.key, required this.taskData});

  @override
  State<TaskPitchingScreen> createState() => _TaskPitchingScreenState();
}

class _TaskPitchingScreenState extends State<TaskPitchingScreen> {
  final TextEditingController _pitchController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pitchController.dispose();
    _budgetController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    final formState = context.read<PitchFormCubit>().state;

    return Scaffold(
      appBar: _buildAppBar(res),
      body: _buildBody(res, colorScheme, formState),
    );
  }

  PreferredSizeWidget _buildAppBar(Responsive res) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      title: Text('Submit Your Pitch', style: TextStyle(fontSize: res.sp(18))),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildBody(
    Responsive res,
    ColorScheme colorScheme,
    PitchFormState formState,
  ) {
    return BlocConsumer<PitchFormCubit, PitchFormState>(
        listenWhen: (previous, current) {
    return previous.success != current.success || previous.error != current.error;
  },
      listener: (context, state) {
        if (state.success) {
           SuccessDialog.show(
      context,
      "Pitch submitted successfully!",
      onClose: () {
        Navigator.pop(context); // Pop the SubmitPitchScreen
      },
    );
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
            SingleChildScrollView(
              padding: EdgeInsets.all(res.wp(5)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PitchTaskDetails(
                      context: context,
                      widget: widget,
                      res: res,
                      colorScheme: colorScheme,
                    ),
                    SizedBox(height: res.hp(3.5)),
                    PitchPayementTypeSection(
                      context: context,
                      res: res,
                      colorScheme: colorScheme,
                    ),
                    SizedBox(height: res.hp(3)),
                    PitchSection(
                      context: context,
                      pitchController: _pitchController,
                      res: res,
                      colorScheme: colorScheme,
                    ),
                    SizedBox(height: res.hp(2.5)),
                    PitchBudgetSection(
                      widget: widget,
                      context: context,
                      budgetController: _budgetController,
                      res: res,
                      colorScheme: colorScheme,
                      formState: state,
                    ),
                    if (state.paymentType == PaymentType.hourly) ...[
                      SizedBox(height: res.hp(2)),
                      HoursSection(
                        context: context,
                        hoursController: _hoursController,
                        res: res,
                        colorScheme: colorScheme,
                      ),
                    ],
                    SizedBox(height: res.hp(3)),
                    TimeLineSection(
                      context: context,
                      res: res,
                      colorScheme: colorScheme,
                    ),
                    SizedBox(height: res.hp(4)),
                    _buildSubmitButton(res, colorScheme, state),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton(
    Responsive res,
    ColorScheme colorScheme,
    PitchFormState state,
  ) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: 'SUBMIT PITCH',
        onPressed:
            state.isSubmitting
                ? null
                : () {
                  if (_formKey.currentState!.validate()) {
                    context.read<PitchFormCubit>().submitPitch(
                      taskData: widget.taskData,
                      pitchText: _pitchController.text,
                      budget: _budgetController.text,
                      hours: _hoursController.text,
                    );
                  }
                },
        isLoading: state.isSubmitting,
      ),
    );
  }
}
