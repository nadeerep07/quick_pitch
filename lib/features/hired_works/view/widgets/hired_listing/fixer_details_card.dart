import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

class FixerDetailsCard extends StatelessWidget {
  final String fixerId;
  final HireRequestStatus hireStatus;

  const FixerDetailsCard({required this.fixerId, required this.hireStatus});

  @override
  Widget build(BuildContext context) {
    final userProfileService = UserProfileService();

    return FutureBuilder<DocumentSnapshot>(
      future: userProfileService.getProfileDocument(fixerId, 'fixer'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        if (userData == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: userData['profileImage'] != null ? NetworkImage(userData['profileImage']) : null,
                child: userData['profileImage'] == null
                    ? Text(userData['name']?.substring(0, 1).toUpperCase() ?? 'F', style: const TextStyle(fontWeight: FontWeight.bold))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fixer: ${userData['name'] ?? 'Unknown'}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    if (userData['phone'] != null)
                      Text(userData['phone'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              if (hireStatus == HireRequestStatus.accepted)
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green.shade600),
                  onPressed: () {
                    // Show contact dialog
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
