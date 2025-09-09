import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/payment/view/payment_confirmation_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/payment_decline_dialog.dart';
import 'package:quick_pitch_app/features/payment/components/razorpay_config.dart';
import 'package:quick_pitch_app/features/payment/service/hire_payment_services.dart';

class HirePaymentSection extends StatefulWidget {
  final HireRequest hireRequest;
  final String userPhone;
  final String userName;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onPaymentDeclined;

  const HirePaymentSection({
    super.key,
    required this.hireRequest,
    required this.userPhone,
    required this.userName,
    this.onPaymentCompleted,
    this.onPaymentDeclined,
  });

  @override
  State<HirePaymentSection> createState() => _HirePaymentSectionState();
}

class _HirePaymentSectionState extends State<HirePaymentSection> {
  final HirePaymentService _hirePaymentService = HirePaymentService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    // Only show for completed hire requests
    if (widget.hireRequest.status != HireRequestStatus.completed) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      color: _getBackgroundColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _getBorderColor(), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(res, theme),
            SizedBox(height: res.hp(2)),
            _buildContent(context, res, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Responsive res, ThemeData theme) {
    return Row(
      children: [
        Icon(
          _getStatusIcon(),
          color: _getStatusColor(),
          size: res.wp(6),
        ),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Status',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getStatusText(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (widget.hireRequest.hasPaymentRequest || widget.hireRequest.isPaymentCompleted)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(3),
              vertical: res.hp(0.5),
            ),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getStatusColor().withOpacity(0.3)),
            ),
            child: Text(
              '₹${_getDisplayAmount().toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Responsive res, ThemeData theme) {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return _buildPaymentRequestedContent(context, res, theme);
      case 'completed':
        return _buildPaymentCompletedContent(res, theme);
      case 'declined':
        return _buildPaymentDeclinedContent(context, res, theme);
      default:
        return _buildNoPaymentContent(context, res, theme);
    }
  }

  Widget _buildPaymentRequestedContent(BuildContext context, Responsive res, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.orange[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Requested',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.hireRequest.paymentRequestNotes?.isNotEmpty == true)
                      Text(
                        widget.hireRequest.paymentRequestNotes!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : () => _handlePaymentDecline(context),
                icon: Icon(Icons.cancel_outlined, size: res.wp(4)),
                label: Text(_isProcessing ? 'Processing...' : 'Decline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[600],
                  side: BorderSide(color: Colors.red[300]!),
                ),
              ),
            ),
            SizedBox(width: res.wp(3)),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : () => _showPaymentConfirmationDialog(context),
                icon: _isProcessing 
                    ? SizedBox(
                        width: res.wp(4),
                        height: res.wp(4),
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.payment, size: res.wp(4)),
                label: Text(_isProcessing ? 'Processing...' : 'Pay Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentCompletedContent(Responsive res, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Completed',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                  ),
                ),
                if (widget.hireRequest.paymentCompletedAt != null)
                  Text(
                    'Paid on ${_formatDate(widget.hireRequest.paymentCompletedAt!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green[600],
                    ),
                  ),
                if (widget.hireRequest.transactionId != null)
                  Text(
                    'Transaction ID: ${widget.hireRequest.transactionId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDeclinedContent(BuildContext context, Responsive res, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Declined',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.red[800],
                      ),
                    ),
                    if (widget.hireRequest.paymentDeclineReason?.isNotEmpty == true)
                      Text(
                        widget.hireRequest.paymentDeclineReason!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : () => _showPaymentConfirmationDialog(context),
            icon: _isProcessing 
                ? SizedBox(
                    width: res.wp(4),
                    height: res.wp(4),
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(Icons.payment, size: res.wp(4)),
            label: Text(_isProcessing ? 'Processing...' : 'Pay Original Amount'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoPaymentContent(BuildContext context, Responsive res, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600], size: res.wp(5)),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Text(
                  'Task completed successfully. Make payment to the fixer.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : () => _showPaymentConfirmationDialog(context),
            icon: _isProcessing 
                ? SizedBox(
                    width: res.wp(4),
                    height: res.wp(4),
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(Icons.payment, size: res.wp(4)),
            label: Text(_isProcessing 
                ? 'Processing...' 
                : 'Pay ₹${widget.hireRequest.workAmount.toStringAsFixed(0)}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        paymentType: PaymentType.hireRequest,
        hireRequest: widget.hireRequest,
        razorpayKeyId: RazorpayConfig.keyId,
        userPhone: widget.userPhone,
        userName: widget.userName,
        isFromRequest: widget.hireRequest.hasPaymentRequest,
        onPaymentSuccess: (paymentId, amount) async {
          Navigator.of(context).pop();
          await _handlePaymentSuccess(paymentId, amount);
        },
        onPaymentError: (error) {
          _showErrorDialog(context, error);
        },
      ),
    );
  }

  Future<void> _handlePaymentSuccess(String paymentId, double amount) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Update Firebase with payment completion
      await _hirePaymentService.markPaymentCompleted(
        hireRequestId: widget.hireRequest.id,
        paidAmount: amount,
        transactionId: paymentId,
      );

      _showSuccessDialog(context, paymentId, amount);
      widget.onPaymentCompleted?.call();
    } catch (e) {
      print('Error updating payment status: $e');
      _showErrorDialog(context, 'Payment processed but failed to update status: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _handlePaymentDecline(BuildContext context) async {
    // Show decline reason dialog
    final reason = await _showDeclineReasonDialog(context);
    if (reason != null && reason.isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });

      try {
        await _hirePaymentService.declinePaymentRequest(
          hireRequestId: widget.hireRequest.id,
          reason: reason,
        );

        widget.onPaymentDeclined?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment request declined'),
            backgroundColor: Colors.orange,
          ),
        );
      } catch (e) {
        print('Error declining payment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error declining payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<String?> _showDeclineReasonDialog(BuildContext context) async {
    String reason = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for declining the payment:'),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => reason = value,
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(reason),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String paymentId, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Payment ID: $paymentId'),
            Text('Amount: ₹${amount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red, size: 60),
            SizedBox(height: 16),
            Text(
              'Payment Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(error),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showPaymentConfirmationDialog(context);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return Colors.orange[50]!;
      case 'completed':
        return Colors.green[50]!;
      case 'declined':
        return Colors.red[50]!;
      default:
        return Colors.blue[50]!;
    }
  }

  Color _getBorderColor() {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return Colors.orange[200]!;
      case 'completed':
        return Colors.green[200]!;
      case 'declined':
        return Colors.red[200]!;
      default:
        return Colors.blue[200]!;
    }
  }

  Color _getStatusColor() {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return Colors.orange[600]!;
      case 'completed':
        return Colors.green[600]!;
      case 'declined':
        return Colors.red[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return Icons.payment;
      case 'completed':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getStatusText() {
    switch (widget.hireRequest.paymentStatus) {
      case 'requested':
        return 'Payment Requested';
      case 'completed':
        return 'Payment Completed';
      case 'declined':
        return 'Payment Declined';
      default:
        return 'Payment Pending';
    }
  }

  double _getDisplayAmount() {
    if (widget.hireRequest.paidAmount != null) {
      return widget.hireRequest.paidAmount!;
    }
    return widget.hireRequest.effectivePaymentAmount;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}