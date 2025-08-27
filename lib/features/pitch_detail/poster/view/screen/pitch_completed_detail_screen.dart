import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_completed_detail/completed_pitch_payment_action_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/main_detail/fixer_profile_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/main_detail/pitch_details_section.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchCompletedDetailScreen extends StatelessWidget {
  final TaskPostModel task;
  final String? pitchId;

  const PitchCompletedDetailScreen({
    super.key,
    required this.task,
    this.pitchId,
  });

  @override
  Widget build(BuildContext context) {
    final pitchDoc =
        FirebaseFirestore.instance.collection('pitches').doc(pitchId);

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          SafeArea(
            child: FutureBuilder<DocumentSnapshot>(
              future: pitchDoc.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Pitch not found"));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final pitch = PitchModel.fromJson(data);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FixerProfileSection(pitch: pitch),
                      // const SizedBox(height: 20),
                    //  TaskDetailsSection(task: task),
                      const SizedBox(height: 20),
                      PitchDetailsSection(pitch: pitch),
                      const SizedBox(height: 20),
                      CompletedPitchPaymentActionButton(),
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
