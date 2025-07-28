import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/requests/poster/viewmodel/cubit/pitches_state.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PitchDetailScreen extends StatelessWidget {
  final PitchModel pitch;
  final TaskPostModel task;

  const PitchDetailScreen({super.key, required this.pitch, required this.task});

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
          'Pitch Details',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: MainBackgroundPainter(),
            size: Size.infinite,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight,
              bottom: res.hp(4),
              left: res.wp(5),
              right: res.wp(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixer Profile Card
                FutureBuilder<UserProfileModel?>(
                  future: context.read<PitchesCubit>().getFixerDetails(pitch.fixerId),
                  builder: (context, snapshot) {
                    final fixer = snapshot.data;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(res.wp(4)),
                      ),
                      color: colorScheme.surface.withOpacity(0.9),
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
                                      fixer?.name?.substring(0, 1) ?? "?",
                                      style: TextStyle(fontSize: res.sp(20)),
                                      
                                    )
                                    :  null
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
                                            .map((skill) => Chip(
                                                  label: Text(
                                                    skill,
                                                    style: TextStyle(
                                                      fontSize: res.sp(10)),
                                                  ),
                                                  backgroundColor: colorScheme.primaryContainer,
                                                  visualDensity: VisualDensity.compact,
                                                ))
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
                ),
                SizedBox(height: res.hp(3)),

                // Task Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(4)),
                  ),
                  color: colorScheme.surface.withOpacity(0.9),
                  child: Padding(
                    padding: EdgeInsets.all(res.wp(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Details',
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: res.hp(1.5)),
                        _buildDetailRow(
                          res,
                          icon: Icons.title,
                          label: 'Title',
                          value: task.title,
                        ),
                        _buildDetailRow(
                          res,
                          icon: Icons.description,
                          label: 'Description',
                          value: task.description,
                        ),
                        _buildDetailRow(
                          res,
                          icon: Icons.attach_money,
                          label: 'Budget',
                          value: '\$${task.budget}',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: res.hp(3)),

                // Pitch Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(4)),
                  ),
                  color: colorScheme.surface.withOpacity(0.9),
                  child: Padding(
                    padding: EdgeInsets.all(res.wp(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pitch Details',
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: res.hp(1.5)),
                        _buildDetailRow(
                          res,
                          icon: Icons.message,
                          label: 'Pitch',
                          value: pitch.pitchText,
                          isMultiLine: true,
                        ),
                        _buildDetailRow(
                          res,
                          icon: Icons.payments,
                          label: 'Proposed Budget',
                          value: '\$${pitch.budget}',
                        ),
                        _buildDetailRow(
                          res,
                          icon: Icons.schedule,
                          label: 'Timeline',
                          value: pitch.timeline,
                        ),
                        _buildDetailRow(
                          res,
                          icon: Icons.payment,
                          label: 'Payment Type',
                          value: pitch.paymentType.name,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: res.hp(4)),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Accept pitch logic
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(res.wp(3)),
                          ),
                          backgroundColor: AppColors.loginscreen,
                        ),
                        child: Text(
                          'Accept Pitch',
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: res.wp(4)),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Reject pitch logic
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(res.wp(3)),
                          ),
                          side: BorderSide(color: colorScheme.error),
                        ),
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    Responsive res, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: res.hp(1.5)),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: res.wp(5), color: Colors.grey),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: res.sp(12),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: res.hp(0.5)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}