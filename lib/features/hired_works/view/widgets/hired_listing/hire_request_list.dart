import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/components/hire_works_listing/hire_listing_empty_widget.dart';
import 'package:quick_pitch_app/features/hired_works/view/components/hire_works_listing/hire_listingerror_widget.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/hire_request_card.dart';

class HireRequestList extends StatelessWidget {
  final HireRequestStatus? status;
  final String currentUserId;
  final String userPhone;
  final String userName;

  const HireRequestList({super.key, 
    required this.status,
    required this.currentUserId,
    required this.userPhone,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collectionGroup('hire_requests')
        .where('posterId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status!.name);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return HireListingErrorWidget();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return HireListingEmptyWidget(status: status);
        }

        return RefreshIndicator(
          onRefresh: () async => {},
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final hireRequest = HireRequest.fromFirestore(doc);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HireRequestCard(
                  hireRequest: hireRequest,
                  userPhone: userPhone,
                  userName: userName,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
