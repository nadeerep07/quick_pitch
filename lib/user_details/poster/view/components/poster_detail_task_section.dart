import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterDetailTaskSection extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const PosterDetailTaskSection({
    super.key,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // Example tasks - replace with actual data from your model
    final exampleTasks = [
      {
        'title': 'Home Painting',
        'description': 'Need interior walls painted in 3BHK apartment',
        'budget': '\$500',
        'date': 'Posted 2 days ago'
      },
      {
        'title': 'Furniture Assembly',
        'description': 'Help assemble IKEA furniture (sofa and bed)',
        'budget': '\$150',
        'date': 'Posted 1 week ago'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(1)),
        ...exampleTasks.map((task) => Container(
          margin: EdgeInsets.only(bottom: res.hp(2)),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title']!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: res.hp(1)),
                Text(
                  task['description']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: res.hp(1.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task['budget']!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      task['date']!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}