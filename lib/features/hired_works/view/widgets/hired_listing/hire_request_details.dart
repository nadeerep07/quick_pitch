import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/components/hire_payment_section.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/payment_status_chip.dart';
import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/status_chip.dart';

class HireRequestDetails extends StatelessWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final VoidCallback onPaymentCompleted;
  final VoidCallback onPaymentDeclined;

  const HireRequestDetails({
    super.key,
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
    required this.onPaymentCompleted,
    required this.onPaymentDeclined,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title and Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  hireRequest.workTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StatusChip(status: hireRequest.status),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Status
          if (hireRequest.paymentStatus != null) ...[
            PaymentStatusChip(status: hireRequest.paymentStatus!),
            const SizedBox(height: 16),
          ],

          // Description
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hireRequest.workDescription,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Work Images
          if (hireRequest.workImages.isNotEmpty) ...[
            Text(
              'Work Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hireRequest.workImages.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          hireRequest.workImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.error),
                              ),
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Amount & Time
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Amount',
                  '₹${hireRequest.workAmount.toStringAsFixed(0)}',
                  Icons.currency_rupee,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  'Time Required',
                  hireRequest.workTime,
                  Icons.access_time,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Section for completed works
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
              onPaymentCompleted: onPaymentCompleted,
              onPaymentDeclined: onPaymentDeclined,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryText),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
