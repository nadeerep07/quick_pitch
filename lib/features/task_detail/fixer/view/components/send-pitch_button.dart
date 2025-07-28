import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';

class SendPitchButton extends StatelessWidget {
  final Responsive res;
  final TaskPostModel task;

  const SendPitchButton({super.key, required this.res,required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(res.wp(5)),
      child: SizedBox(
        width: double.infinity,
        height: res.hp(6),
        child:AppButton(text:  "Send Pitch", onPressed:  () {
             Navigator.pushNamed(context, AppRoutes.taskPicting,arguments: task);
          },)
      ),
    );
  }
}
