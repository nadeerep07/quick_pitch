import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/loading_widget.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitches_content.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';

class PitchesTab extends StatelessWidget {
  const PitchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PitchesCubit, PitchesState>(
      builder: (context, state) {
        if (state is PitchesLoading) {
          return const LoadingWidget();
        } else if (state is PitchesError) {
          return ErrorWidget(state.message);
        } else if (state is PitchesLoaded) {
          final pending = state.pending;
          if (pending.isEmpty) {
            return Center(child: Text("No Pitches Avaialable"));
          }
          return PitchesContent(groupedPitches: pending);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
