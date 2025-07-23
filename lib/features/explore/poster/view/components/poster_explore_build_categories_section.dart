import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/category_background_painter.dart';

class PosterExploreBuildCategoriesSection extends StatelessWidget {
  const PosterExploreBuildCategoriesSection({
    super.key,
    required this.res,
    required this.theme,
  });

  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
  final categories = [
    {'icon': Icons.home_repair_service, 'label': 'Home Repair'},
    {'icon': Icons.cleaning_services, 'label': 'Cleaning'},
    {'icon': Icons.electric_bolt, 'label': 'Electrical'},
    {'icon': Icons.plumbing, 'label': 'Plumbing'},
    {'icon': Icons.grass, 'label': 'Landscaping'},
    {'icon': Icons.more_horiz, 'label': 'More'},
  ];

  return Container(
    padding: EdgeInsets.all(res.wp(4)),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .05),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: res.hp(2)),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: res.wp(4),
            mainAxisSpacing: res.hp(2),
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle category selection
              },
              child: CustomPaint(
                painter: CategoryBackgroundPainter(
                  baseColor: theme.colorScheme.surface,
                  highlightColor: theme.colorScheme.primary.withValues(alpha: .1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: res.wp(15),
                      height: res.wp(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: .1),
                            theme.colorScheme.primary.withValues(alpha: .2),
                          ],
                        ),
                      ),
                      child: Icon(
                        categories[index]['icon'] as IconData,
                        size: res.sp(22),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: res.hp(1)),
                    Text(
                      categories[index]['label'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
}
