import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_state.dart';

class PitchStatusChips extends StatelessWidget {
  final PitchFormState state;
  final Responsive res;
  final ThemeData theme;

  const PitchStatusChips({
    super.key,
    required this.state,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: res.wp(12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
        children: [
          _buildChip(context, 'All', state.pitches.length),
          SizedBox(width: res.wp(2)),
          _buildChip(
            context,
            'Accepted',
            state.pitches.where((p) => p.status == 'accepted').length,
          ),
          SizedBox(width: res.wp(2)),
          _buildChip(
            context,
            'Pending',
            state.pitches.where((p) => p.status == 'pending').length,
          ),
          SizedBox(width: res.wp(2)),
          _buildChip(
            context,
            'Declined',
            state.pitches.where((p) => p.status == 'declined').length,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, int count) {
    final isActive = state.selectedFilter == label;
    return GestureDetector(
      onTap: () => context.read<PitchFormCubit>().changeFilter(label),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: theme.dividerColor),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(4),
          vertical: res.wp(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: res.sp(12),
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: res.wp(1.5)),
            CircleAvatar(
              radius: res.wp(2.5),
              backgroundColor: isActive
                  ? Colors.white
                  : theme.primaryColor.withValues(alpha: 0.1),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: res.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isActive ? theme.primaryColor : theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
