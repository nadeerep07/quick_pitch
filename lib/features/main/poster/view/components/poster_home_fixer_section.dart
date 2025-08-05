import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_empty_state.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomeFixerSection extends StatelessWidget {
  const PosterHomeFixerSection({
    super.key,
    required this.res,
    required this.state,
    required this.context,
  });

  final Responsive res;
  final PosterHomeLoaded state;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    if (state.fixers.isEmpty) {
      return Container(
        margin: EdgeInsets.all(res.wp(5)),
        child: PosterHomeEmptyState(res: res, title: 'No Fixers Available', subtitle: 'Check back later for available fixers', icon: Icons.people_outline),
      );
    }

    final recommendedFixers = state.fixers.take(5).toList();

    return Container(
      margin: EdgeInsets.fromLTRB(res.wp(5), res.hp(3), 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: res.wp(5)),
            child: Text(
              'Recommended Fixers',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          SizedBox(height: res.hp(1.5)),
          SizedBox(
            height: res.hp(15),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: res.wp(5)),
              itemCount: recommendedFixers.length,
              separatorBuilder: (_, __) => SizedBox(width: res.wp(3)),
              itemBuilder: (context, index) {
                final fixer = recommendedFixers[index];
                return PosterHomeFixerCard(context: context, res: res, fixer: fixer);
              },
            ),
          ),
        ],
      ),
    );
  }
}
