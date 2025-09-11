import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/hired_works/view/components/hire_payment_section.dart';
import 'package:quick_pitch_app/features/payment/service/hire_payment_services.dart';

class HiredWorksScreen extends StatefulWidget {
  const HiredWorksScreen({super.key});

  @override
  State<HiredWorksScreen> createState() => _HiredWorksScreenState();
}

class _HiredWorksScreenState extends State<HiredWorksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentUserId;
  final UserProfileService userProfileService = UserProfileService();

  // User info for payments
  String userPhone = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (currentUserId != null) {
      try {
        final userDoc = await userProfileService.getProfileDocument(
          currentUserId!,
          'poster',
        );
        final userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            userName = userData['name'] ?? 'User';
            userPhone = userData['phone'] ?? '';
          });
        }
      } catch (e) {
        print('Error loading user info: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hired Works',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue.shade700,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue.shade700,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
            Tab(text: 'Declined'),
          ],
        ),
      ),
      body:
          currentUserId == null
              ? const Center(
                child: Text(
                  'Please log in to view your hired works',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildHireRequestsList(null),
                  _buildHireRequestsList(HireRequestStatus.pending),
                  _buildHireRequestsList(HireRequestStatus.accepted),
                  _buildHireRequestsList(HireRequestStatus.completed),
                  _buildHireRequestsList(HireRequestStatus.declined),
                ],
              ),
    );
  }

  Widget _buildHireRequestsList(HireRequestStatus? status) {
    Query query = FirebaseFirestore.instance
        .collectionGroup('hire_requests')
        .where('posterId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error fetching hired works: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading hired works',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  status == null
                      ? 'No hired works yet'
                      : 'No ${status.displayName.toLowerCase()} works',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your hired works will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {}); // Trigger rebuild
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final hireRequest = HireRequest.fromFirestore(doc);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    _buildHireRequestCard(hireRequest),
                    // Add payment section for completed tasks
                    // Replace this section in your _buildHireRequestsList method:

                    // Add payment section for completed tasks that haven't been paid
                   
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handlePaymentCompleted(HireRequest hireRequest) async {
    try {
      // The payment completion will be handled by the payment service
      // when the payment succeeds in Razorpay
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handlePaymentDeclined(HireRequest hireRequest) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment request declined'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error declining payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildHireRequestCard(HireRequest hireRequest) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showHireRequestDetails(hireRequest),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(hireRequest.status),
                  Text(
                    _formatDate(hireRequest.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Work Title
              Text(
                hireRequest.workTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Work Description
              Text(
                hireRequest.workDescription,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Amount and Time Row
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                  Text(
                    hireRequest.workAmount.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hireRequest.workTime,
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
                  ),
                ],
              ),

              // Payment Status Indicator (if applicable)
              if (hireRequest.paymentStatus != null) ...[
                const SizedBox(height: 12),
                _buildPaymentStatusChip(hireRequest.paymentStatus!),
              ],

              const SizedBox(height: 12),

              // Fixer Details (if available)
              if (hireRequest.status != HireRequestStatus.pending)
                FutureBuilder<DocumentSnapshot>(
                  future: userProfileService.getProfileDocument(
                    hireRequest.fixerId,
                    'fixer',
                  ),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>?;
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
                            backgroundImage:
                                userData['profileImage'] != null
                                    ? NetworkImage(userData['profileImage'])
                                    : null,
                            child:
                                userData['profileImage'] == null
                                    ? Text(
                                      userData['name']
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          'F',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fixer: ${userData['name'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                if (userData['phone'] != null)
                                  Text(
                                    userData['phone'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (hireRequest.status == HireRequestStatus.accepted)
                            IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.green.shade600,
                              ),
                              onPressed: () {
                                _showContactDialog(userData);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),

              // Response Date (if responded)
              if (hireRequest.respondedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Responded on: ${_formatDate(hireRequest.respondedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String paymentStatus) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (paymentStatus) {
      case 'requested':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.payment;
        text = 'Payment Requested';
        break;
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        text = 'Payment Completed';
        break;
      case 'declined':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        text = 'Payment Declined';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Icons.info;
        text = 'Payment Status Unknown';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(HireRequestStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case HireRequestStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.hourglass_empty;
        break;
      case HireRequestStatus.accepted:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Icons.check_circle_outline;
        break;
      case HireRequestStatus.completed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.done_all;
        break;
      case HireRequestStatus.declined:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel_outlined;
        break;
      case HireRequestStatus.cancelled:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        icon = Icons.block;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showHireRequestDetails(HireRequest hireRequest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
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
                            _buildStatusChip(hireRequest.status),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Payment Status (if applicable)
                        if (hireRequest.paymentStatus != null) ...[
                          _buildPaymentStatusChip(hireRequest.paymentStatus!),
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
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
                                                    Icons.error,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Amount and Time
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

                        // Payment Details (if applicable)
                        if (hireRequest.paymentStatus != null) ...[
                          if (hireRequest.requestedPaymentAmount != null)
                            _buildInfoCard(
                              'Requested Amount',
                              '₹${hireRequest.requestedPaymentAmount!.toStringAsFixed(0)}',
                              Icons.payment,
                              Colors.orange,
                            ),
                          if (hireRequest.paidAmount != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              'Paid Amount',
                              '₹${hireRequest.paidAmount!.toStringAsFixed(0)}',
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ],
                          const SizedBox(height: 16),
                        ],

                        // Dates
                        _buildInfoCard(
                          'Request Date',
                          _formatFullDate(hireRequest.createdAt),
                          Icons.calendar_today,
                          Colors.purple,
                        ),

                        if (hireRequest.respondedAt != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            'Response Date',
                            _formatFullDate(hireRequest.respondedAt!),
                            Icons.reply,
                            Colors.orange,
                          ),
                        ],

                        // Payment Dates
                        if (hireRequest.paymentRequestedAt != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            'Payment Requested',
                            _formatFullDate(hireRequest.paymentRequestedAt!),
                            Icons.payment,
                            Colors.orange,
                          ),
                        ],

                        if (hireRequest.paymentCompletedAt != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            'Payment Completed',
                            _formatFullDate(hireRequest.paymentCompletedAt!),
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ],

                        // Message (if any)
                        if (hireRequest.message != null &&
                            hireRequest.message!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              hireRequest.message!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],

                        // Payment Notes (if any)
                        if (hireRequest.paymentRequestNotes != null &&
                            hireRequest.paymentRequestNotes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Payment Request Notes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Text(
                              hireRequest.paymentRequestNotes!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],

                        // Payment Decline Reason (if any)
                        if (hireRequest.paymentDeclineReason != null &&
                            hireRequest.paymentDeclineReason!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Payment Decline Reason',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              hireRequest.paymentDeclineReason!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
 if (hireRequest.status == HireRequestStatus.completed &&
                        userPhone.isNotEmpty &&
                        userName.isNotEmpty &&
                        (hireRequest.paymentStatus == null ||
                            hireRequest.paymentStatus == 'requested' ||
                            hireRequest.paymentStatus == 'declined'))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: HirePaymentSection(
                          hireRequest: hireRequest,
                          userPhone: userPhone,
                          userName: userName,
                          onPaymentCompleted:
                              () => _handlePaymentCompleted(hireRequest),
                          onPaymentDeclined:
                              () => _handlePaymentDeclined(hireRequest),
                        ),
                      ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
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

  void _showContactDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Contact ${userData['name'] ?? 'Fixer'}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData['phone'] != null)
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(userData['phone']),
                    subtitle: const Text('Phone'),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement phone call functionality
                    },
                  ),
                if (userData['email'] != null)
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(userData['email']),
                    subtitle: const Text('Email'),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement email functionality
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
