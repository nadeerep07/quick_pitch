import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/components/poster_detail_about_section.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/components/poster_detail_build_header.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/components/poster_detail_rating_button.dart';
import 'package:quick_pitch_app/features/user_details/poster/view/components/poster_detail_task_section.dart';

class PosterDetailScreen extends StatelessWidget {
  final UserProfileModel posterData;

  const PosterDetailScreen({super.key, required this.posterData});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header with profile image and background
          SliverAppBar(
            expandedHeight: res.hp(25),
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  posterData.posterData?.coverImageUrl?.isNotEmpty == true
                      ? Image.network(
                        posterData.posterData?.coverImageUrl ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : CustomPaint(
                        size: Size(double.infinity, res.hp(25)),
                        painter: MainBackgroundPainter(),
                      ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: res.hp(2)),
                      child: Hero(
                        tag: 'poster-${posterData.name}',
                        child: CircleAvatar(
                          radius: res.wp(15),
                          backgroundColor: colorScheme.surface,
                          child: CircleAvatar(
                            radius: res.wp(14.5),
                            backgroundImage: NetworkImage(
                              posterData.profileImageUrl?.isNotEmpty == true
                                  ? posterData.profileImageUrl!
                                  : 'https://i.pravatar.cc/300?u=${posterData.name}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: res.hp(1)),

                  // Name and basic info
                  PosterDetailBuildHeader(
                    posterData: posterData,
                    res: res,
                    theme: theme,
                  ),
                  SizedBox(height: res.hp(2)),

                  // Rating and action buttons
                  PosterDetailRatingButton(res: res, colorScheme: colorScheme
                      , poster: posterData),
                  SizedBox(height: res.hp(3)),

                  // About section
                  PosterDetailAboutSection(
                    posterData: posterData,
                    res: res,
                    theme: theme,
                  ),
                  SizedBox(height: res.hp(3)),

                  // Tasks section
                  PosterDetailTaskSection(res: res, theme: theme),
                  SizedBox(height: res.hp(4)),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed bottom button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: AppButton(
          text: 'Contact ${posterData.name.split(' ').first}',
          onPressed: () {
            // Handle contact poster action
          },
        ),
      ),
    );
  }
}
