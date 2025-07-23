import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreFixerSection extends StatelessWidget {
  const PosterExploreFixerSection({
    super.key,
    required this.res,
    required this.theme,
  });

  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final popularFixers = [
      {
        'name': 'Alex Johnson',
        'rating': 4.8,
        'reviews': 42,
        'skill': 'Home Repair Specialist',
        'image': 'https://randomuser.me/api/portraits/men/32.jpg'
      },
      {
        'name': 'Maria Garcia',
        'rating': 4.9,
        'reviews': 56,
        'skill': 'Cleaning Expert',
        'image': 'https://randomuser.me/api/portraits/women/44.jpg'
      },
      {
        'name': 'James Wilson',
        'rating': 4.7,
        'reviews': 38,
        'skill': 'Electrician',
        'image': 'https://randomuser.me/api/portraits/men/75.jpg'
      },
    ];

   return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ... existing header row ...
      SizedBox(height: res.hp(1)),
      SizedBox(
        height: res.hp(24), // Increased height to accommodate all content
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popularFixers.length,
          itemBuilder: (context, index) {
            return Container(
              width: res.wp(60),
              margin: EdgeInsets.only(right: res.wp(4)),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Important fix
                children: [
                  // Image section
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      height: res.hp(12),
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Image.network(
                        popularFixers[index]['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, size: res.sp(30));
                        },
                      ),
                    ),
                  ),
                  // Content section
                  Expanded( // Use Expanded to take remaining space
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(res.wp(3)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Important fix
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            popularFixers[index]['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: res.hp(0.3)),
                          Text(
                            popularFixers[index]['skill'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(), // Pushes rating to bottom
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  size: res.sp(14), color: Colors.amber),
                              SizedBox(width: res.wp(1)),
                              Text(
                                '${popularFixers[index]['rating']}',
                                style: theme.textTheme.bodySmall,
                              ),
                              SizedBox(width: res.wp(1)),
                              Text(
                                '(${popularFixers[index]['reviews']} reviews)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
  }
}