import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';

/// Fixer name widget
class FixerName extends StatelessWidget {
  final String fixerId;
  const FixerName({required this.fixerId});

  @override
  Widget build(BuildContext context) => FutureBuilder<UserProfileModel?>(
        future: context.read<PitchesCubit>().getFixerDetails(fixerId),
        builder: (context, snapshot) {
          final fixerName = snapshot.data?.name ?? 'Fixer';
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Completed by',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500, fontSize: 11)),
                Text(fixerName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700)),
              ]);
        },
      );
}

