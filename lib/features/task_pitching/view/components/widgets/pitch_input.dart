import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PitchInput extends StatelessWidget {
  const PitchInput({
    super.key,
    required TextEditingController pitchController,
    required this.res,
    required this.colorScheme,
  }) : _pitchController = pitchController;

  final TextEditingController _pitchController;
  final Responsive res;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: res.wp(2.5),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
      ),
      child: TextFormField(
        controller: _pitchController,
        maxLines: 6,
        style: TextStyle(color: colorScheme.onSurface, fontSize: res.sp(14)),
        decoration: InputDecoration(
          hintText: 'Explain why you\'re the best fit for this task...',
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: res.sp(14),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(res.wp(3)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: EdgeInsets.all(res.wp(4)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter your pitch';
          if (value.length < 50) return 'Pitch should be at least 50 characters';
          return null;
        },
      ),
    );
  }
}
