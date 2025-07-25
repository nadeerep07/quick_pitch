import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_image_header.dart';

import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_detail_section_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_poster_section.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_skills_section.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/fixer_task_overview_section.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/view/components/send-pitch_button.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/viewmodel/cubit/fixer_detail_cubit.dart';

class FixerSideDetailScreen extends StatelessWidget {
  final TaskPostModel task;

  const FixerSideDetailScreen({super.key, required this.task});

@override
Widget build(BuildContext context) {
  final res = Responsive(context);
  return BlocProvider(
    create: (_) => FixerDetailCubit()..fetchPosterProfile(task.posterId),
    child: Scaffold(
      appBar: AppBar(
        title: Text(task.title, style: TextStyle(fontSize: res.sp(16))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          Padding(
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(2), res.wp(5), res.hp(2)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FixerDetailImageHeader(imageUrls: task.imagesUrl, res: res, priorityLabel: task.priority, ),
                  SizedBox(height: res.hp(2)),
                  FixerDetailSectionTitle(title: "Task Details", icon: Icons.info_outline, res: res),
                  FixerTaskOverviewSection(task: task, res: res),
                  FixerSkillsSection(skills: task.skills, res: res),
                  SizedBox(height: res.hp(3)),
                  FixerDetailSectionTitle(title: "Posted by", icon: Icons.person, res: res),
                  SizedBox(height: res.hp(1)),
                  FixerPosterSection(res: res),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SendPitchButton(res: res),
    ),
  );
}

}
