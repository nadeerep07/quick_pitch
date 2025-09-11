import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/components/hire_payment_section.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/fixer_details_card.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/hire_request_details.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/payment_status_chip.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/status_chip.dart';

class HireRequestCard extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;

  const HireRequestCard({
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showHireRequestDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusChip(status: hireRequest.status),
                  Text(
                    _formatDate(hireRequest.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                hireRequest.workTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                hireRequest.workDescription,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Amount & Time
              Row(
                children: [
                  Icon(Icons.currency_rupee, size: 16, color: Colors.green.shade600),
                  Text(
                    '${hireRequest.workAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: 4),
                  Text(hireRequest.workTime, style: TextStyle(fontSize: 14, color: Colors.blue.shade600)),
                ],
              ),
              const SizedBox(height: 12),
              if (hireRequest.paymentStatus != null)
                PaymentStatusChip(status: hireRequest.paymentStatus!),
              const SizedBox(height: 12),
              if (hireRequest.status != HireRequestStatus.pending)
                FixerDetailsCard(fixerId: hireRequest.fixerId, hireStatus: hireRequest.status),
              const SizedBox(height: 8),
              if (hireRequest.status == HireRequestStatus.completed &&
                  userPhone.isNotEmpty &&
                  userName.isNotEmpty &&
                  (hireRequest.paymentStatus == null ||
                      hireRequest.paymentStatus == 'requested' ||
                      hireRequest.paymentStatus == 'declined'))
                HirePaymentSection(
                  hireRequest: hireRequest,
                  userPhone: userPhone,
                  userName: userName,
                  onPaymentCompleted: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment completed!'), backgroundColor: Colors.green),
                    );
                  },
                  onPaymentDeclined: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment declined'), backgroundColor: Colors.orange),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHireRequestDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: HireRequestDetails(hireRequest: hireRequest, userPhone: userPhone, userName: userName),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
