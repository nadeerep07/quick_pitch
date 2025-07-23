import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_action_button.dart';

class PosterHomeQuickActions extends StatelessWidget {
  const PosterHomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        PosterHomeQuickActionButton(
          res: res,
          icon: Icons.chat,
          label: "Chats",
        ),
        PosterHomeQuickActionButton(
          res: res,
          icon: Icons.history,
          label: "My Tasks",
        ),
        PosterHomeQuickActionButton(
          res: res,
          icon: Icons.person_search,
          label: "Find Fixer",
        ),
      ],
    );
  }
}
