import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_bloc.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_event.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_state.dart';

class HireRequestDetailScreen extends StatelessWidget {
  final HireRequest request;

  const HireRequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<HireRequestsBloc, HireRequestsState>(
        listener: (context, state) {
          if (state is RequestProcessingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            if (state.message.contains('completed')) {
              Navigator.pop(context);
            }
          } else if (state is RequestProcessingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(res.wp(4)),
                decoration: BoxDecoration(
                  color: StatusColorUtil.getStatusColor(
                    request.status.displayName,
                    theme,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: StatusColorUtil.getStatusColor(
                      request.status.displayName,
                      theme,
                    ).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(request.status),
                      color: StatusColorUtil.getStatusColor(
                        request.status.displayName,
                        theme,
                      ),
                      size: res.wp(6),
                    ),
                    SizedBox(width: res.wp(3)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: res.sp(12),
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          request.status.displayName,
                          style: TextStyle(
                            fontSize: res.sp(18),
                            fontWeight: FontWeight.bold,
                            color: StatusColorUtil.getStatusColor(
                              request.status.displayName,
                              theme,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (request.respondedAt != null)
                      Text(
                        _formatDate(request.respondedAt!),
                        style: TextStyle(
                          fontSize: res.sp(12),
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: res.wp(6)),

              // Payment Status Section - Only show if work is completed or has payment activity
              if (_shouldShowPaymentSection()) ...[
                _buildPaymentStatusCard(res, theme),
                SizedBox(height: res.wp(4)),
              ],

              // Client Details Section
              _buildSectionCard(res, theme, 'Client Details', Icons.person, [
                _buildDetailRow(
                  res,
                  theme,
                  'Name',
                  request.posterName,
                  leadingWidget: CircleAvatar(
                    radius: res.wp(4),
                    backgroundImage:
                        request.posterImage.isNotEmpty
                            ? NetworkImage(request.posterImage)
                            : null,
                    child:
                        request.posterImage.isEmpty
                            ? Icon(Icons.person, size: res.wp(4))
                            : null,
                  ),
                ),
                _buildDetailRow(
                  res,
                  theme,
                  'Request Date',
                  _formatDate(request.createdAt),
                ),
                if (request.message != null && request.message!.isNotEmpty)
                  _buildDetailRow(
                    res,
                    theme,
                    'Message',
                    request.message!,
                    isMultiline: true,
                  ),
              ]),

              SizedBox(height: res.wp(4)),

              // Work Details Section
              _buildSectionCard(res, theme, 'Work Details', Icons.work, [
                _buildDetailRow(
                  res,
                  theme,
                  'Title',
                  request.workTitle,
                  isMultiline: true,
                ),
                if (request.workDescription.isNotEmpty)
                  _buildDetailRow(
                    res,
                    theme,
                    'Description',
                    request.workDescription,
                    isMultiline: true,
                  ),
                _buildDetailRow(
                  res,
                  theme,
                  'Amount',
                  '₹${request.workAmount.toStringAsFixed(0)}',
                  valueColor: AppColors.primaryColor,
                  valueWeight: FontWeight.bold,
                ),
                if (request.workTime.isNotEmpty)
                  _buildDetailRow(res, theme, 'Duration', request.workTime),
              ]),

              // Work Images Section
              if (request.workImages.isNotEmpty) ...[
                SizedBox(height: res.wp(4)),
                _buildSectionCard(res, theme, 'Work Images', Icons.image, [
                  SizedBox(
                    height: res.wp(40),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: request.workImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: res.wp(3)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              request.workImages[index],
                              width: res.wp(32),
                              height: res.wp(40),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: res.wp(32),
                                  height: res.wp(40),
                                  color: colorScheme.outline.withOpacity(0.1),
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: colorScheme.outline,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ],

              SizedBox(height: res.wp(6)),

            if (request.status == HireRequestStatus.accepted) ...[
                SizedBox(
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
                ),
              ] 

      
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowPaymentSection() {
    return request.status == HireRequestStatus.completed || 
           request.paymentStatus != null;
  }

  Widget _buildPaymentStatusCard(Responsive res, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (request.isPaymentCompleted) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Payment Completed';
    } else if (request.hasPaymentRequest) {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
      statusText = 'Payment Requested';
    } else if (request.isPaymentDeclined) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Payment Declined';
    } else if (request.canRequestPayment) {
      statusColor = Colors.blue;
      statusIcon = Icons.payment;
      statusText = 'Ready to Request Payment';
    } else {
      statusColor = colorScheme.outline;
      statusIcon = Icons.payment;
      statusText = 'No Payment Activity';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: statusColor,
                size: res.wp(5),
              ),
              SizedBox(width: res.wp(2)),
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.wp(3)),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: res.wp(5)),
              SizedBox(width: res.wp(2)),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (request.requestedPaymentAmount != null) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Requested Amount',
              '₹${request.requestedPaymentAmount!.toStringAsFixed(0)}',
            ),
          ],
          if (request.paidAmount != null) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Paid Amount',
              '₹${request.paidAmount!.toStringAsFixed(0)}',
              valueColor: Colors.green,
            ),
          ],
          if (request.paymentRequestedAt != null) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Requested On',
              _formatDate(request.paymentRequestedAt!),
            ),
          ],
          if (request.paymentCompletedAt != null) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Completed On',
              _formatDate(request.paymentCompletedAt!),
              valueColor: Colors.green,
            ),
          ],
          if (request.paymentDeclinedAt != null) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Declined On',
              _formatDate(request.paymentDeclinedAt!),
              valueColor: Colors.red,
            ),
          ],
          if (request.paymentDeclineReason != null && request.paymentDeclineReason!.isNotEmpty) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Decline Reason',
              request.paymentDeclineReason!,
              isMultiline: true,
              valueColor: Colors.red,
            ),
          ],
          if (request.paymentRequestNotes != null && request.paymentRequestNotes!.isNotEmpty) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Request Notes',
              request.paymentRequestNotes!,
              isMultiline: true,
            ),
          ],
          if (request.transactionId != null && request.transactionId!.isNotEmpty) ...[
            SizedBox(height: res.wp(2)),
            _buildPaymentDetailRow(
              res,
              theme,
              'Transaction ID',
              request.transactionId!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(
    Responsive res,
    ThemeData theme,
    String label,
    String value, {
    bool isMultiline = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: res.wp(0.5)),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: res.wp(25),
            child: Text(
              label,
              style: TextStyle(
                fontSize: res.sp(13),
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: res.wp(2)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: res.sp(13),
                color: valueColor ?? theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    Responsive res,
    ThemeData theme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: res.wp(5), color: theme.colorScheme.primary),
              SizedBox(width: res.wp(2)),
              Text(
                title,
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: res.wp(4)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    Responsive res,
    ThemeData theme,
    String label,
    String value, {
    bool isMultiline = false,
    Color? valueColor,
    FontWeight? valueWeight,
    Widget? leadingWidget,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: res.wp(1.5)),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (leadingWidget != null) ...[
            leadingWidget,
            SizedBox(width: res.wp(3)),
          ],
          SizedBox(
            width: res.wp(20),
            child: Text(
              label,
              style: TextStyle(
                fontSize: res.sp(14),
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: res.sp(14),
                color: valueColor ?? theme.colorScheme.onSurface,
                fontWeight: valueWeight ?? FontWeight.normal,
              ),
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(HireRequestStatus status) {
    switch (status) {
      case HireRequestStatus.pending:
        return Icons.hourglass_empty;
      case HireRequestStatus.accepted:
        return Icons.check_circle;
      case HireRequestStatus.declined:
        return Icons.cancel;
      case HireRequestStatus.completed:
        return Icons.task_alt;
      case HireRequestStatus.cancelled:
        return Icons.block;
    }
  }

  

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
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
                  print(
                    'Dispatching CompleteRequest with ID: ${request.id}',
                  ); // Debug
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



  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}