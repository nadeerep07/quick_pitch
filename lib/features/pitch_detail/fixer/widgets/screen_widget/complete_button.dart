import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_bloc.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_event.dart';

class CompleteButton extends StatelessWidget {
  final HireRequest request;

  const CompleteButton({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: res.wp(3)),
        ),
        onPressed: () => _showCompleteDialog(context),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text(
          'Mark as Complete',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mark as Complete'),
        content: Text(
          'Are you sure you want to mark this request as completed?\n\nThis will notify ${request.posterName} that the work has been finished.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HireRequestsBloc>().add(
                    CompleteRequest(request.id),
                  );
            },
            child: const Text(
              'Complete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
