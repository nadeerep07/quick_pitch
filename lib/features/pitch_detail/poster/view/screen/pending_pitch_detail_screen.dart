import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/action_buttons_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/fixer_profile_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/pitch_details_section.dart';
import 'package:quick_pitch_app/features/pitch_detail/poster/view/components/task_details_section.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PendingPitchDetailScreen extends StatelessWidget {
  final PitchModel pitch;
  final TaskPostModel task;

  const PendingPitchDetailScreen({super.key, required this.pitch, required this.task});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, res,),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
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
                FixerProfileSection(pitch: pitch),
                SizedBox(height: res.hp(3)),
                TaskDetailsSection(task: task),
                SizedBox(height: res.hp(3)),
                PitchDetailsSection(pitch: pitch),
                SizedBox(height: res.hp(4)),
                ActionButtonsSection(pitch: pitch,task: task,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Responsive res,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Pitch Details',
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: res.sp(18),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}





