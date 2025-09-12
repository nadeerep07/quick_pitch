import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/widget/pitch_detail_content.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/widget/pitch_not_found_view.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';


class CompleteBody extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;
  final Responsive res;
  final ThemeData theme;

  const CompleteBody({
    super.key,
    required this.task,
    required this.pitchId,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final pitchDocRef =
        FirebaseFirestore.instance.collection('pitches').doc(pitchId);

    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: pitchDocRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PitchLoadingView(res: res, theme: theme);
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return PitchNotFoundView(res: res, theme: theme);
          }

          final pitch =
              PitchModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return PitchDetailContent(
            task: task,
            pitch: pitch,
            res: res,
          );
        },
      ),
    );
  }
}
class PitchLoadingView extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const PitchLoadingView({
    super.key,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: res.hp(2)),
          Text(
            'Loading details...',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
