import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreEmpty extends StatelessWidget {
  const PosterExploreEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(res.wp(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: res.wp(32),
            height: res.wp(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: res.sp(48),
              color: Colors.grey[400],
            ),
          ),

          SizedBox(height: res.hp(3)),

          Text(
            'No fixers found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: res.hp(1)),

          Text(
            'Try adjusting your search terms or filters to find more results.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: res.hp(4)),

          ElevatedButton.icon(
            onPressed: () {
              // Clear filters or refresh
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(6),
                vertical: res.hp(1.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



