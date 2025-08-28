import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/view/components/no_pitches_message.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/view/components/pitch_status_chips.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/view/components/pitches_list.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/view/components/request_shimmer.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class FixerPitchStatusTab extends StatefulWidget {
  const FixerPitchStatusTab({super.key});

  @override
  State<FixerPitchStatusTab> createState() => _FixerPitchStatusTabState();
}

class _FixerPitchStatusTabState extends State<FixerPitchStatusTab> {
  late final String fixerId;

  @override
  void initState() {
    super.initState();
    fixerId = FirebaseAuth.instance.currentUser!.uid;
    context.read<PitchFormCubit>().fetchFixerPitches(fixerId);
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return BlocBuilder<PitchFormCubit, PitchFormState>(
      builder: (context, state) {
        if (state.isSubmitting && state.pitches.isEmpty) {
          return RequestsShimmer(res: res);
        }

        if (state.error != null && state.pitches.isEmpty) {
          debugPrint("Error fetching pitches: ${state.error}");
          return Center(
            child: Text(
              "Could not load pitches.\n${state.error}",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }

        // 🔹 Filter pitches
        final filteredPitches = _getFilteredPitches(state);

        return Column(
          children: [
            SizedBox(height: res.wp(3)),

            /// Filter Chips
            PitchStatusChips(
              state: state,
              res: res,
              theme: theme,
            ),

            SizedBox(height: res.wp(3)),

            /// Pitches List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<PitchFormCubit>()
                      .fetchFixerPitches(fixerId); 
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

  /// Helper for filtering pitches by status
  List<PitchModel> _getFilteredPitches(PitchFormState state) {
    switch (state.selectedFilter) {
      case 'Accepted':
        return state.pitches
            .where((p) => p.status.toLowerCase() == 'accepted')
            .toList();
      case 'Pending':
        return state.pitches
            .where((p) => p.status.toLowerCase() == 'pending')
            .toList();
      case 'Declined':
        return state.pitches
            .where((p) => p.status.toLowerCase() == 'rejected') // ✅ fixed
            .toList();
      default:
        return state.pitches;
    }
  }
}

