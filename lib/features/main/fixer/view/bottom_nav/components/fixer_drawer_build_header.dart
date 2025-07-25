// Section-wise refactored FixerCustomDrawer

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';

class FixerDrawerBuildHeader extends StatelessWidget {
  const FixerDrawerBuildHeader({
    super.key,
    required this.context,
    required this.userData,
    required this.theme,
  });

  final BuildContext context;
  final dynamic userData;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: .7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (userData?.fixerData?.coverImageUrl != null &&
              userData!.fixerData!.coverImageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
                child:  CustomPaint(painter: MainBackgroundPainter()),
              ),
            )
          else
            CustomPaint(painter: MainBackgroundPainter()),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child:
                              (userData?.profileImageUrl ?? '').isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/default_user.png',
                                    image: userData!.profileImageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    'assets/images/default_user.png',
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${userData?.name ?? 'User'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              userData?.role.toUpperCase() ?? 'FIXER',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
