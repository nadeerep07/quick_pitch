import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/budget_input.dart';
import 'package:quick_pitch_app/features/task_pitching/view/components/widgets/section_title.dart';
import 'package:quick_pitch_app/features/task_pitching/view/screen/task_pitching_screen.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchBudgetSection extends StatelessWidget {
  const PitchBudgetSection({
    super.key,
    required this.widget,
    required this.context,
    required TextEditingController budgetController,
    required this.res,
    required this.colorScheme,
    required this.formState,
  }) : _budgetController = budgetController;

  final TaskPitchingScreen widget;
  final BuildContext context;
  final TextEditingController _budgetController;
  final Responsive res;
  final ColorScheme colorScheme;
  final PitchFormState formState;

  @override
  Widget build(BuildContext context) {
    final double minBudget = widget.taskData.budget * 0.8;
    final double maxBudget = widget.taskData.budget * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(context: context, title: formState.paymentType == PaymentType.fixed 
              ? 'PROPOSED FIXED BUDGET' 
              : 'PROPOSED HOURLY RATE', res: res, colorScheme: colorScheme),
        SizedBox(height: res.hp(1)),
        BudgetInput(budgetController: _budgetController, res: res, colorScheme: colorScheme, minBudget: minBudget, maxBudget: maxBudget),
      ],
    );
  }
}
