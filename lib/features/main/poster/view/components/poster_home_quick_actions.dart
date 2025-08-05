import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_action_button.dart';

class PosterHomeQuickActions extends StatelessWidget {
  const PosterHomeQuickActions({
    super.key,
    required this.res,
    required this.context,
  });

  final Responsive res;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: res.wp(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: res.hp(1.5)),
          Row(
            children: [
              Expanded(
                child: PosterHomeQuickActionButton(res: res, title: 'Post Task', icon: Icons.add_task, color: const Color(0xFF3B82F6), onTap: () {}),
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: PosterHomeQuickActionButton(res: res, title: 'Find Fixer', icon: Icons.search, color: const Color(0xFF10B981), onTap: () {}),
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: PosterHomeQuickActionButton(res: res, title: 'Messages', icon: Icons.chat_bubble_outline, color: const Color(0xFF8B5CF6), onTap: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
