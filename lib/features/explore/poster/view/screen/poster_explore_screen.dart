import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_build_categories_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_fixer_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_nearby_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/poster_explore_search_bar.dart';

class PosterExploreScreen extends StatelessWidget {
  const PosterExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App bar with search
          SliverAppBar(
            expandedHeight: res.hp(15),
            floating: true,
            pinned: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CustomPaint(
                    size: Size(double.infinity, res.hp(15)),
                    painter: MainBackgroundPainter(),
                  ),
                  Positioned(
                    left: res.wp(5),
                    right: res.wp(5),
                    bottom: res.hp(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        SizedBox(height: res.hp(1)),
                        Text(
                          'Discover Fixers, skills, or services',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryText,
                          ),
                        ),
                        SizedBox(height: res.hp(2)),
                        PosterExploreSearchBar(res: res, theme: theme),
                      ],
                    ),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.zero,
            ),
          ),

          // Content sections
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(5),
              vertical: res.hp(2),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Categories section
                PosterExploreBuildCategoriesSection(res: res, theme: theme),
                SizedBox(height: res.hp(3)),

                // Popular Fixers section
                PosterExploreFixerSection(res: res, theme: theme),
                SizedBox(height: res.hp(3)),

                // Nearby section
                PosterExploreNearbySection(res: res, theme: theme),
              ]),
            ),
          ),
          
        ],
      ),
    );
  }
}
