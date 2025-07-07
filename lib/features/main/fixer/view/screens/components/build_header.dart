import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class BuildHeader extends StatelessWidget {
  final Responsive res;
  final Map<String, dynamic> profile;
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
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: CircleAvatar(
            radius: res.hp(3.5),
            backgroundImage: (profile['profileImageUrl']?.isNotEmpty ?? false)
                ? NetworkImage(profile['profileImageUrl'])
                : const AssetImage('assets/images/default_user.png')
                    as ImageProvider,
          ),
        ),
        SizedBox(width: res.wp(3)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile['name'] ?? 'Unknown',
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
                profile[' role '] ?? ' Fixer ',
                style: TextStyle(color: Colors.white, fontSize: res.sp(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

