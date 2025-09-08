import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/screen/fixie_ai_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_action_button.dart';
import 'package:quick_pitch_app/features/settings/view/screen/settings_screen.dart' ;
import 'package:quick_pitch_app/features/task_detail/poster/view/screen/poster_task_detail_listview_screen.dart';

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
                child: PosterHomeQuickActionButton(res: res, title: 'Fixie AI', icon: Icons.auto_awesome, color: const Color(0xFF3B82F6), onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> FixieAiScreen()));
                }),
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: PosterHomeQuickActionButton(res: res, title: 'My Tasks', icon: Icons.add_task, color: const Color(0xFF10B981), onTap: () {
                   Navigator.push(context,MaterialPageRoute(builder: (context)=>PosterTaskDetailListviewScreen()));
                }),
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: PosterHomeQuickActionButton(res: res, title: 'Settings', icon: Icons.settings, color: const Color(0xFF8B5CF6), onTap: () {
                  // Navigate to Messages Screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppSettings()));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
