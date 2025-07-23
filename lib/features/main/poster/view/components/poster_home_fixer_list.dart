import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/screen/fixer_detail_screen.dart';

class PosterHomeFixerList extends StatelessWidget {
  const PosterHomeFixerList({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return BlocBuilder<PosterHomeCubit, PosterHomeState>(
      builder: (context, state) {
        if (state is PosterHomeLoaded) {
          final fixers = state.fixers;
          final recommendFixer = fixers.take(5).toList();
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
                height: res.hp(20.5),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendFixer.length,
                  separatorBuilder: (_, __) => SizedBox(width: res.wp(3)),
                  itemBuilder: (context, index) {
                    final fixer = recommendFixer[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FixerDetailScreen(fixerData: fixer,),
                          ),
                        );
                      },
                      child: PosterHomeFixerCard(
                        res: res,
                        name: fixer.name,
                        skill: fixer.fixerData?.skills?.first ?? 'General',
                        imageUrl:
                            fixer.profileImageUrl ??
                            'https://i.pravatar.cc/150?img=3',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is PosterHomeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PosterHomeError) {
          //   print('Error: ${state.message}');
          return Center(
            child: Text(
              state.message,
              style: TextStyle(fontSize: res.sp(14), color: Colors.red),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No fixers available',
              style: TextStyle(fontSize: res.sp(14), color: Colors.grey),
            ),
          );
        }
      },
    );
  }
}
