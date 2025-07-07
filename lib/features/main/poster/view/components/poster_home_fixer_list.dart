import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_card.dart';

class PosterHomeFixerList extends StatelessWidget {
  const PosterHomeFixerList({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    // 🔹 You can later fetch recommended fixers from Cubit or API if needed
    final fixers = [
      {'name': 'Rahul', 'skill': 'Electrician'},
      {'name': 'Anjali', 'skill': 'Painter'},
      {'name': 'Manoj', 'skill': 'AC Technician'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Fixers',
          style: TextStyle(
            fontSize: res.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(1)),
        SizedBox(
          height: res.hp(15),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: fixers.length,
            separatorBuilder: (_, __) => SizedBox(width: res.wp(3)),
            itemBuilder: (context, index) {
              final fixer = fixers[index];
              return PosterHomeFixerCard(
                res: res,
                name: fixer['name']!,
                skill: fixer['skill']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
