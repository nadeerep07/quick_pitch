import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quick_pitch_app/features/Pitch_detail/poster/view/screen/Pitch_detail_screen.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PitchesCubit>().loadPitches();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Requests on My Tasks',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          BlocBuilder<PitchesCubit, PitchesState>(
            builder: (context, state) {
              if (state is PitchesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PitchesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                );
              } else if (state is PitchesLoaded) {
                if (state.groupedPitches.isEmpty) {
                  return Center(
                    child: Text(
                      "No pitches received yet",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(
                    top: res.hp(2),
                    bottom: res.hp(4),
                    left: res.wp(4),
                    right: res.wp(4),
                  ),
                  child: ListView.builder(
                    itemCount: state.groupedPitches.length,
                    itemBuilder: (context, index) {
                      final task =
                          state.groupedPitches[index]['task'] as TaskPostModel;
                      final pitches =
                          state.groupedPitches[index]['pitches']
                              as List<PitchModel>;
                      final fixerPitches = _groupPitchesByFixer(pitches);

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(res.wp(4)),
                        ),
                        color: colorScheme.surface.withOpacity(0.9),
                        child: ExpansionTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: res.sp(16),
                            ),
                          ),

                          subtitle: Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: res.sp(12)),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(res.wp(4)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fixers who pitched:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: res.sp(14),
                                    ),
                                  ),

                                  SizedBox(height: res.hp(1.5)),
                                  _buildFixerAvatars(
                                    context,
                                    fixerPitches,
                                    task,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFixerAvatars(
    BuildContext context,
    Map<String, List<PitchModel>> fixerPitches,
    TaskPostModel task,
  ) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;
    final fixerIds = fixerPitches.keys.toList();
    final maxVisibleAvatars = 1;

    return Column(
      children: [
        SizedBox(
          height: res.wp(14), // Avatar size + padding
          child: Stack(
            children: [
              for (int i = 0; i < fixerIds.length && i < maxVisibleAvatars; i++)
                Positioned(
                  left: i * res.wp(8), // Overlapping avatars
                  child: _buildFixerAvatar(
                    context,
                    fixerId: fixerIds[i],
                    pitch: fixerPitches[fixerIds[i]]!.first,
                    task: task,
                  ),
                ),
              if (fixerIds.length > maxVisibleAvatars)
                Positioned(
                  left: maxVisibleAvatars * res.wp(8),
                  child: GestureDetector(
                    onTap:
                        () => _showAllFixersDialog(
                          context,
                          fixerPitches: fixerPitches,
                          task: task,
                        ),
                    child: Container(
                      width: res.wp(12),
                      height: res.wp(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '+${fixerIds.length - maxVisibleAvatars}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (fixerIds.length > maxVisibleAvatars)
          Padding(
            padding: EdgeInsets.only(top: res.hp(1)),
            child: TextButton(
              onPressed:
                  () => _showAllFixersDialog(
                    context,
                    fixerPitches: fixerPitches,
                    task: task,
                  ),
              child: Text(
                'View all ${fixerIds.length} fixers',
                style: TextStyle(
                  fontSize: res.sp(12),
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFixerAvatar(
    BuildContext context, {
    required String fixerId,
    required PitchModel pitch,
    required TaskPostModel task,
  }) {
    final res = Responsive(context);

    return FutureBuilder<UserProfileModel?>(
      future: context.read<PitchesCubit>().getFixerDetails(fixerId),
      builder: (context, snapshot) {
        final fixer = snapshot.data;
        return GestureDetector(
          onTap:
              () => _showFixerPitchesDialog(
                context,
                fixer: fixer,
                pitches: [pitch], // Show all pitches when clicked
                task: task,
              ),
          child: Container(
            width: res.wp(12),
            height: res.wp(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  fixer?.profileImageUrl != null
                      ? CachedNetworkImageProvider(fixer!.profileImageUrl!)
                      : null,
              child:
                  fixer?.profileImageUrl == null
                      ? Text(
                        fixer?.name?.substring(0, 1) ?? "?",
                        style: TextStyle(fontSize: res.sp(16)),
                      )
                      : null,
            ),
          ),
        );
      },
    );
  }

  Map<String, List<PitchModel>> _groupPitchesByFixer(List<PitchModel> pitches) {
    final Map<String, List<PitchModel>> result = {};

    for (final pitch in pitches) {
      if (pitch.fixerId != null) {
        if (!result.containsKey(pitch.fixerId)) {
          result[pitch.fixerId!] = [];
        }
        result[pitch.fixerId!]!.add(pitch);
      }
    }

    return result;
  }

  void _showFixerPitchesDialog(
    BuildContext context, {
    required UserProfileModel? fixer,
    required List<PitchModel> pitches,
    required TaskPostModel task,
  }) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colorScheme.surface.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(res.wp(4)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: res.wp(6),
                        backgroundImage:
                            fixer?.profileImageUrl != null
                                ? CachedNetworkImageProvider(
                                  fixer!.profileImageUrl!,
                                )
                                : null,
                        child:
                            fixer?.profileImageUrl == null
                                ? Text(fixer?.name?.substring(0, 1) ?? "?")
                                : null,
                      ),
                      SizedBox(width: res.wp(4)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fixer?.name ?? "Unknown Fixer",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: res.sp(16),
                              ),
                            ),
                            if (fixer?.fixerData?.skills != null &&
                                fixer!.fixerData!.skills!.isNotEmpty)
                              Text(
                                fixer.fixerData!.skills!.join(", "),
                                style: TextStyle(
                                  fontSize: res.sp(12),
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(2)),
                  Text(
                    'Pitches for ${task.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: res.sp(14),
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  ...pitches.map((pitch) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: res.hp(0.5)),
                      child: ListTile(
                        title: Text(pitch.pitchText),
                        subtitle: Text(
                          '${pitch.paymentType.name.toUpperCase()} • \$${pitch.budget}',
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      PitchDetailScreen(pitch: pitch, task: task),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  SizedBox(height: res.hp(1)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllFixersDialog(
    BuildContext context, {
    required Map<String, List<PitchModel>> fixerPitches,
    required TaskPostModel task,
  }) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colorScheme.surface.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Fixers for ${task.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: res.sp(16),
                  ),
                ),
                SizedBox(height: res.hp(1)),
                ...fixerPitches.keys.map((fixerId) {
                  final pitches = fixerPitches[fixerId]!;
                  return FutureBuilder<UserProfileModel?>(
                    future: context.read<PitchesCubit>().getFixerDetails(
                      fixerId,
                    ),
                    builder: (context, snapshot) {
                      final fixer = snapshot.data;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: res.hp(0.5)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                fixer?.profileImageUrl != null
                                    ? CachedNetworkImageProvider(
                                      fixer!.profileImageUrl!,
                                    )
                                    : null,
                            child:
                                fixer?.profileImageUrl == null
                                    ? Text(fixer?.name?.substring(0, 1) ?? "?")
                                    : null,
                          ),
                          title: Text(fixer?.name ?? "Unknown Fixer"),
                          subtitle: Text(
                            '${pitches.length} ${pitches.length == 1 ? 'pitch' : 'pitches'} • \$${pitches.first.budget}',
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showFixerPitchesDialog(
                              context,
                              fixer: fixer,
                              pitches: pitches,
                              task: task,
                            );
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
                SizedBox(height: res.hp(1)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
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
