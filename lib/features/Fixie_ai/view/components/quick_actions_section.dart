// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/widget/quick_action_chip.dart';

class QuickActionsSection extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Responsive responsive;
  final Function(String) onActionPressed;

  const QuickActionsSection({
    super.key,
    required this.slideAnimation,
    required this.responsive,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        height: responsive.hp(8),
        margin: EdgeInsets.symmetric(vertical: responsive.hp(2)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
          children: [
            QuickActionChip(
              label: 'Structure my pitch',
              icon: Icons.rocket_launch,
              color: Colors.deepPurple.shade500,
              responsive: responsive,
              onTap: () => onActionPressed('Structure my pitch'),
            ),
            QuickActionChip(
              label: 'Improve my Pitch',
              icon: Icons.trending_up,
              color: Colors.deepPurple.shade600,
              responsive: responsive,
              onTap: () => onActionPressed('Improve my Pitch'),
            ),
            QuickActionChip(
              label: 'Market analysis',
              icon: Icons.analytics,
              color: Colors.deepPurple.shade800,
              responsive: responsive,
              onTap: () => onActionPressed('Market analysis'),
            ),
          ],
        ),
      ),
    );
  }
}
