import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class AvatarContainer extends StatelessWidget {
  final UserProfileModel? fixer;
  final double size;

  const AvatarContainer({super.key, 
    required this.fixer,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: fixer?.profileImageUrl != null
            ? CachedNetworkImageProvider(fixer!.profileImageUrl!)
            : const AssetImage('assets/images/avatar_photo_placeholder.jpg'),
        child: fixer?.profileImageUrl == null
            ? Text(
                fixer?.name.substring(0, 1) ?? "?",
                style: TextStyle(fontSize: res.sp(16)),
              )
            : null,
      ),
    );
  }
}
