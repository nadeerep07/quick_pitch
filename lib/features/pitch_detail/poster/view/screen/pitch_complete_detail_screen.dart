import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/pitch_assigned_detail_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_assigned_detail/pitch_assigned_update_history_list.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchCompleteDetailScreen extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;
  const PitchCompleteDetailScreen({super.key,required this.task,required this.pitchId});

  @override
  Widget build(BuildContext context) {
       final pitchDocRef = FirebaseFirestore.instance.collection('pitches').doc(pitchId);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: pitchDocRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text("Pitch not found", style: theme.textTheme.titleMedium));
                }

                final pitch = PitchModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      //                FixerProfileSection(pitch: pitch),
                      PitchDetailCard(task: task, pitch: pitch),
                      const SizedBox(height: 24),
                      UpdateHistoryList(pitchDocRef: pitchDocRef),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}