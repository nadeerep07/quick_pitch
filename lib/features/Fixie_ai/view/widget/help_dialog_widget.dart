// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class HelpDialogWidget extends StatelessWidget {
  final Responsive responsive;

  const HelpDialogWidget({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.wp(5)),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.deepPurple.shade600,
            Colors.deepPurple.shade800,
          ],
        ).createShader(bounds),
        child: Text(
          'How Fixie AI can help',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: responsive.sp(18),
          ),
        ),
      ),
      content: Text(
        'Structure your business pitch\n'
        'Improve your presentation deck\n'
        'Practice investor questions\n'
        'Get market analysis tips\n'
        'Refine your business strategy\n'
        'Perfect your pitch delivery\n\n'
        'Just ask me anything related to pitching and business presentations!',
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          height: 1.5,
          fontSize: responsive.sp(14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(6),
              vertical: responsive.hp(1),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade500,
                  Colors.deepPurple.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(responsive.wp(4)),
            ),
            child: Text(
              'Got it',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: responsive.sp(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}