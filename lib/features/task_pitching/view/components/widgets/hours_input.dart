import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class HoursInput extends StatelessWidget {
  const HoursInput({
    super.key,
    required TextEditingController hoursController,
    required this.res,
    required this.colorScheme,
  }) : _hoursController = hoursController;

  final TextEditingController _hoursController;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchFormCubit, PitchFormState>(
      builder: (context, formState) {
        return TextFormField(
          controller: _hoursController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: colorScheme.onSurface, fontSize: res.sp(14)),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.timer_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: res.wp(5),
            ),
            hintText: 'Enter estimated hours',
            hintStyle: TextStyle(fontSize: res.sp(14)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(res.wp(3)),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              vertical: res.hp(2),
              horizontal: res.wp(4),
            ),
          ),
          validator: (value) {
            if (formState.paymentType == PaymentType.hourly) {
              if (value == null || value.isEmpty) return 'Please enter estimated hours';
              if (double.tryParse(value) == null) return 'Enter a valid number';
            }
            return null;
          },
        );
      },
    );
  }
}
