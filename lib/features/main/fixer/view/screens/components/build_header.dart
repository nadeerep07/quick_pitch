import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class BuildHeader extends StatelessWidget {
  final Responsive res;
  final UserProfileModel profile;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BuildHeader({
    super.key,
    required this.res,
    required this.profile,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () { scaffoldKey.currentState?.openDrawer();
          context.read<FixerProfileCubit>().loadFixerProfile();
          },
          child: CircleAvatar(
            radius: res.hp(3.5),
            backgroundImage: (profile.profileImageUrl?.isNotEmpty ?? false)
                ? NetworkImage(profile.profileImageUrl!)
                : const AssetImage('assets/images/default_user.png')
                    as ImageProvider,
          ),
        ),
        SizedBox(width: res.wp(3)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: TextStyle(fontSize: res.sp(18), fontWeight: FontWeight.w600),
            ),
            SizedBox(height: res.hp(0.5)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                profile.role,
                style: TextStyle(color: Colors.white, fontSize: res.sp(12)),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.notifications, size: res.sp(30)),
          onPressed: () {
            // Handle notification tap
          },
          color: AppColors.primaryText,
        ),
      ],
    );
  }
}

