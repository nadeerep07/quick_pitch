import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/components/fixer_detail_about_section.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/components/fixer_detail_build_header.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/components/fixer_detail_portfolio_section.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/components/fixer_detail_rating_button.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/components/fixer_detail_skill_section.dart';

class FixerDetailScreen extends StatelessWidget {
  final UserProfileModel fixerData;

  const FixerDetailScreen({super.key, required this.fixerData});

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
            backgroundColor: Colors.grey[50] ,
            expandedHeight: res.hp(25),
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  fixerData.fixerData?.coverImageUrl?.isNotEmpty == true
                      ? Image.network(
                        fixerData.fixerData?.coverImageUrl ?? '',
                          width: double.infinity, 
                          height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            alignment: Alignment.center,
                            child: Text('Failed to load cover image'),
                          );
                        },
                      )
                      : CustomPaint(
                        size: Size(double.infinity, res.hp(25)),
                        painter: MainBackgroundPainter(),
                      ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: res.hp(2),left: res.wp(3)),
                      child: Hero(
                        tag: 'fixer-${fixerData.name}',
                        child: CircleAvatar(
                          radius: res.wp(13),
                          backgroundColor: colorScheme.surface,
                          child: CircleAvatar(
                            radius: res.wp(12.5),
                            backgroundImage: NetworkImage(
                              fixerData.profileImageUrl?.isNotEmpty == true
                                  ? fixerData.profileImageUrl!
                                  : 'https://i.pravatar.cc/300?u=$fixerData',
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
                  FixerDetailBuildHeader(
                    fixerData: fixerData,
                    res: res,
                    theme: theme,
                  ),
                  SizedBox(height: res.hp(2)),

                  // Rating and action buttons
                  FixerDetailRatingButton(res: res, colorScheme: colorScheme),
                  SizedBox(height: res.hp(3)),

                  // About section
                  FixerDetailAboutSection(
                    fixerData: fixerData,
                    res: res,
                    theme: theme,
                  ),
                  SizedBox(height: res.hp(3)),

                  // Skills section
                  if (fixerData.fixerData?.skills?.isNotEmpty ?? false)
                    FixerDetailSkillSection(
                      fixerData: fixerData,
                      res: res,
                      theme: theme,
                    ),
                  if (fixerData.fixerData?.skills?.isNotEmpty ?? false)
                    SizedBox(height: res.hp(3)),

                  // Portfolio section
                  FixerDetailPortfolioSection(res: res, theme: theme),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: res.hp(2)),
          ),
          onPressed: () {},
          child: Text(
            'Hire ${fixerData.name.split(' ').first}',
            style: TextStyle(
              fontSize: res.sp(16),
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
