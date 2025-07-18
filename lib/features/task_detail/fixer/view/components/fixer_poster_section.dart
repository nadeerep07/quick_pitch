import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_poster_card.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/viewmodel/cubit/fixer_detail_cubit.dart';

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
          return FixerDetailPosterCard(poster: state.poster, res: res);
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
