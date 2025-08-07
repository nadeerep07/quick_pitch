 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/viewmodel/cubit/fixer_pitch_detail_cubit.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

Future<void> showCompletionDialog(BuildContext context,Responsive res,PitchModel currentPitch) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mark Task as Completed', ),
              SizedBox(height: res.hp(2)),
              Text('Add any completion notes for the poster:', ),
              SizedBox(height: res.hp(2)),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter completion notes...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                maxLines: 4,
              ),
              SizedBox(height: res.hp(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  SizedBox(width: res.wp(3)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FixerPitchDetailCubit>().markAsCompleted(currentPitch.id, controller.text);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Complete'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }