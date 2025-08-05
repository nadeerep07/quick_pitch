import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomeUserHeader extends StatelessWidget {
  const PosterHomeUserHeader({
    super.key,
    required this.context,
    required this.res,
    required this.state,
  });

  final BuildContext context;
  final Responsive res;
  final PosterHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (state.userProfile.profileImageUrl?.isNotEmpty ?? false)
            ? state.userProfile.profileImageUrl!
            : 'https://i.pravatar.cc/150?img=3';

    return Container(
      padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(3), res.wp(5), res.hp(2)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.95),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade50,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/avatar_photo_placeholder.jpg',
                    image: imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    imageErrorBuilder:
                        (_, __, ___) => Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: res.wp(4)),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: res.sp(12),
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  state.userProfile.name,
                  style: TextStyle(
                    fontSize: res.sp(18),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF475569),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
