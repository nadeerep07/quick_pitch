import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerDetailPortfolioSection extends StatelessWidget {
  const FixerDetailPortfolioSection({
    super.key,
    required this.res,
    required this.theme,
  });

  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final dummyProjects = [
      {
        'title': 'Kitchen Renovation',
        'image': 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=500',
        'desc': 'Remodeled a modular kitchen with smart storage solutions and modern appliances.',
      },
      {
        'title': 'Home Painting',
        'image': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=500',
        'desc': 'Painted a full 3BHK interior with contemporary color schemes and premium paints.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(1)),
        ...dummyProjects.map((project) => Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  project['image']!,
                  height: res.hp(20),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: res.hp(20),
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(res.wp(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: res.hp(0.5)),
                    Text(
                      project['desc']!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}