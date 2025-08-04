import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

/// Fixer Profile Section
class FixerProfileSection extends StatelessWidget {
  final PitchModel pitch;
  const FixerProfileSection({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<UserProfileModel?>(
      future: context.read<PitchesCubit>().getFixerDetails(pitch.fixerId),
      builder: (context, snapshot) {
        final fixer = snapshot.data;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
          color: colorScheme.surface.withValues(alpha: .9),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: res.wp(8),
                    backgroundImage: fixer?.profileImageUrl != null
                        ? CachedNetworkImageProvider(fixer!.profileImageUrl!)
                        : null,
                    child: fixer?.profileImageUrl == null
                        ? Text(
                            fixer?.name.substring(0, 1) ?? "?",
                            style: TextStyle(fontSize: res.sp(20)),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: res.wp(4)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fixer?.name ?? "Unknown Fixer",
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (fixer?.fixerData?.skills != null &&
                          fixer!.fixerData!.skills!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: res.hp(0.5)),
                          child: Wrap(
                            spacing: res.wp(1.5),
                            runSpacing: res.wp(1),
                            children: fixer.fixerData!.skills!
                                .map(
                                  (skill) => Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(fontSize: res.sp(10)),
                                    ),
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
