import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/no_pitches_message.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/pitch_status_chips.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/pitches_list.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/components/request_shimmer.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class FixerPitchStatusTab extends StatelessWidget {
  const FixerPitchStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final fixerId = FirebaseAuth.instance.currentUser!.uid;
    final res = Responsive(context);
    final theme = Theme.of(context);

    // Fetch data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PitchFormCubit>().fetchFixerPitches(fixerId);
    });

    return BlocBuilder<PitchFormCubit, PitchFormState>(
      builder: (context, state) {
        if (state.isSubmitting) {
          return RequestsShimmer(res: res,);
        }
        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        // Filter pitches
        final filteredPitches = _getFilteredPitches(state);

        return Column(
          children: [
            SizedBox(height: res.wp(3)),

            /// Filter Chips Section
            PitchStatusChips(
              state: state,
              res: res,
              theme: theme,
            ),

            SizedBox(height: res.wp(3)),

            /// Pitches List Section
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<PitchFormCubit>().fetchFixerPitches(fixerId);
                },
                child: filteredPitches.isEmpty
                    ? NoPitchesMessage(
                        filter: state.selectedFilter,
                        res: res,
                        theme: theme,
                      )
                    : PitchesList(
                        pitches: filteredPitches,
                        res: res,
                        theme: theme,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Helper to filter pitches
  List<PitchModel> _getFilteredPitches(PitchFormState state) {
    switch (state.selectedFilter) {
      case 'Accepted':
        return state.pitches.where((p) => p.status == 'accepted').toList();
      case 'Pending':
        return state.pitches.where((p) => p.status == 'pending').toList();
      case 'Declined':
        return state.pitches.where((p) => p.status == 'declined').toList();
      default:
        return state.pitches;
    }
  }
}
