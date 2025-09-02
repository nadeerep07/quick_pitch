import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests_pitches/poster/viewmodel/cubit/pitches_state.dart';

/// Fixer avatar widget
class FixerAvatar extends StatelessWidget {
  final String fixerId;
  const FixerAvatar({super.key, required this.fixerId});

  @override
  Widget build(BuildContext context) => FutureBuilder<UserProfileModel?>(
        future: context.read<PitchesCubit>().getFixerDetails(fixerId),
        builder: (context, snapshot) => CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: (snapshot.hasData &&
                  snapshot.data?.profileImageUrl != null)
              ? NetworkImage(snapshot.data!.profileImageUrl!)
              : null,
          child: (snapshot.hasData &&
                  snapshot.data?.profileImageUrl != null)
              ? null
              : Icon(Icons.person, color: Colors.blue.shade600, size: 16),
        ),
      );
}

