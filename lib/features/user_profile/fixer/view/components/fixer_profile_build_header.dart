// Section-wise refactored FixerProfileScreen

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerProfileBuildHeader extends StatelessWidget {
  const FixerProfileBuildHeader({
    super.key,
    required this.context,
    required this.res,
    required this.profile,
    required this.colorScheme,
  });

  final BuildContext context;
  final Responsive res;
  final dynamic profile;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor:  Colors.grey[50],
      expandedHeight: res.hp(22),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            profile.fixerData?.coverImageUrl?.isNotEmpty == true
                ? Image.network(
                  profile.fixerData!.coverImageUrl!,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Text('Failed to load cover image'),
                        ),
                      ),
                )
                : CustomPaint(
                  size: Size(double.infinity, res.hp(1)),
                  painter: MainBackgroundPainter(),
                ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: res.hp(2),left: res.wp(3)),
                child: GestureDetector(
                  onTap:
                      () =>
                          context.read<FixerProfileCubit>().editProfileImage(),
                  child: CircleAvatar(
                    radius: res.wp(13),
                    backgroundColor: colorScheme.surface,
                    child: CircleAvatar(
                      radius: res.wp(12.5),
                      backgroundImage:
                          profile.profileImageUrl?.isNotEmpty == true
                              ? NetworkImage(profile.profileImageUrl!)
                              : const AssetImage('assets/images/default_user.png')
                                  as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    final cubit = context.read<FixerProfileCubit>();
                    switch (value) {
                      case 'edit_profile':
                        // Add navigation logic here
                        break;
                      case 'change_cover':
                        cubit.uploadCoverImage();
                        break;
                      case 'remove_cover':
                        cubit.removeCoverImage();
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit_profile',
                          child: Text('Edit Profile',style: TextStyle(color:  Colors.white),),
                        ),
                        const PopupMenuItem(
                          value: 'change_cover',
                          child: Text('Change Cover Photo',style: TextStyle(color:  Colors.white),),
                        ),
                        if (profile.fixerData?.coverImageUrl?.isNotEmpty ==
                            true)
                          const PopupMenuItem(
                            value: 'remove_cover',
                            child: Text('Remove Cover Photo',style: TextStyle(color:  Colors.white),),
                          ),
                      ],
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
