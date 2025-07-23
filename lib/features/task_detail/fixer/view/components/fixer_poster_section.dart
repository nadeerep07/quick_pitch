import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_poster_card.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/viewmodel/cubit/fixer_detail_cubit.dart';
import 'package:quick_pitch_app/user_details/poster/view/screen/poster_detail_screen.dart';

class FixerPosterSection extends StatelessWidget {
  final Responsive res;

  const FixerPosterSection({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FixerDetailCubit, FixerDetailState>(
      builder: (context, state) {
        if (state is FixerDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FixerDetailLoaded) {
          return GestureDetector(
            onTap:(){
              Navigator.push(context,MaterialPageRoute(builder: (context) => PosterDetailScreen(posterData: state.poster),));
            },
            child: FixerDetailPosterCard(poster: state.poster, res: res));
        } else if (state is FixerDetailError) {
          return Text(
            state.message,
            style: TextStyle(color: Colors.red),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
