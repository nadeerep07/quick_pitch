import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserProfileModel otherUser;

  const ChatAppBar({super.key, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      foregroundColor: Colors.black,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: otherUser.profileImageUrl != null
                  ? NetworkImage(otherUser.profileImageUrl!)
                  : null,
              child: otherUser.profileImageUrl == null
                  ? Text(otherUser.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 16))
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(otherUser.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(otherUser.role.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
