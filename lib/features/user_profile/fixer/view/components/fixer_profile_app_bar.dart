import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/view/complete_profile_screen.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_cover_image.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerProfileAppBar extends StatelessWidget {
  final dynamic profile;
  final Responsive res;

  const FixerProfileAppBar({
    super.key,
    required this.profile,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: res.hp(18),
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoverImage(),
            _buildAvatar(),
            _buildOverlay(),
            _buildMenuButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final imageUrl = profile.fixerData?.coverImageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return buildCoverImage(imageUrl, 200); // 👈 height = 200 (or adjust)
    } else {
      return _buildDefaultCover();
    }
  }

  Widget _buildDefaultCover() {
    return CustomPaint(painter: MainBackgroundPainter());
  }

  Widget _buildAvatar() {
    return Positioned(
      bottom: res.hp(0.3),
      left: res.wp(1),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: res.wp(12),
          backgroundColor: Colors.grey[200],
          backgroundImage:
              profile.profileImageUrl?.isNotEmpty == true
                  ? NetworkImage(profile.profileImageUrl!)
                  : const AssetImage('assets/images/default_user.png')
                      as ImageProvider,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 16,
      child: Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        child: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit_profile',
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                ),
                const PopupMenuItem(
                  value: 'change_cover',
                  child: Text(
                    'Change Cover Photo',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                ),
                if (profile.fixerData?.coverImageUrl?.isNotEmpty == true)
                  const PopupMenuItem(
                    value: 'remove_cover',
                    child: Text(
                      'Remove Cover Photo',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
              ],
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final cubit = context.read<FixerProfileCubit>();
    switch (value) {
      case 'edit_profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    CompleteProfileScreen(role: profile.role, isEditMode: true),
          ),
        );
        break;
      case 'change_cover':
        cubit.uploadCoverImage();
        break;
      case 'remove_cover':
        cubit.removeCoverImage();
        break;
    }
  }
}
