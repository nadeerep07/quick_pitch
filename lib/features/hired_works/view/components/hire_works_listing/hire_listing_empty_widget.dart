import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

class HireListingEmptyWidget extends StatelessWidget {
  final HireRequestStatus? status;

  const HireListingEmptyWidget({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            status == null ? 'No hired works yet' : 'No ${status!.displayName.toLowerCase()} works',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text('Your hired works will appear here', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
