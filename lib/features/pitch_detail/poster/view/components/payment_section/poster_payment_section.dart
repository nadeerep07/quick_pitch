import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PosterPaymentSection extends StatelessWidget {
  final PitchModel pitch;
  final VoidCallback? onApprovePayment;
  final VoidCallback? onDeclinePayment;
  final VoidCallback? onInitiatePayment;

  const PosterPaymentSection({
    super.key,
    required this.pitch,
    this.onApprovePayment,
    this.onDeclinePayment,
    this.onInitiatePayment,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    // Only show for completed tasks
    if (pitch.status != 'completed') {
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
        Container(
          padding: EdgeInsets.all(res.wp(2)),
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(),
            color: _getIconColor(),
            size: res.wp(5),
          ),
        ),
        SizedBox(width: res.wp(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getHeaderText(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(),
                ),
              ),
              if (_getSubHeaderText() != null) ...[
                SizedBox(height: res.hp(0.5)),
                Text(
                  _getSubHeaderText()!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (pitch.paymentStatus == 'completed')
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(3),
              vertical: res.hp(0.8),
            ),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Colors.green[700], size: res.wp(3.5)),
                SizedBox(width: res.wp(1)),
                Text(
                  'PAID',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Responsive res, ThemeData theme) {
    switch (pitch.paymentStatus) {
      case 'requested':
        return _buildPaymentRequestedContent(context, res, theme);
      case 'completed':
        return _buildPaymentCompletedContent(res, theme);
      default:
        return _buildNoPaymentContent(context, res, theme);
    }
  }

  Widget _buildPaymentRequestedContent(BuildContext context, Responsive res, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alert banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.notification_important, 
                   color: Colors.orange[600], 
                   size: res.wp(4)),
              SizedBox(width: res.wp(2)),
              Expanded(
                child: Text(
                  'The fixer has requested payment for this completed task.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(2)),

        // Payment details
        _buildDetailRow(
          res: res,
          theme: theme,
          icon: Icons.attach_money,
          label: 'Requested Amount',
          value: '\$${pitch.requestedPaymentAmount?.toStringAsFixed(2) ?? pitch.budget.toStringAsFixed(2)}',
          valueColor: Colors.green[600],
        ),
        SizedBox(height: res.hp(1.5)),

        if (pitch.paymentRequestedAt != null) ...[
          _buildDetailRow(
            res: res,
            theme: theme,
            icon: Icons.schedule,
            label: 'Requested On',
            value: DateFormat('MMM dd, yyyy • hh:mm a').format(pitch.paymentRequestedAt!),
          ),
          SizedBox(height: res.hp(1.5)),
        ],

        if (pitch.paymentRequestNotes != null && pitch.paymentRequestNotes!.isNotEmpty) ...[
          _buildDetailRow(
            res: res,
            theme: theme,
            icon: Icons.note_alt_outlined,
            label: 'Request Notes',
            value: pitch.paymentRequestNotes!,
            isMultiline: true,
          ),
          SizedBox(height: res.hp(2)),
        ],

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onDeclinePayment,
                icon: Icon(Icons.close, size: res.wp(4)),
                label: Text('Decline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[600],
                  side: BorderSide(color: Colors.red[300]!, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: res.wp(3)),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onApprovePayment,
                icon: Icon(Icons.check, size: res.wp(4)),
                label: Text('Approve & Pay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentCompletedContent(Responsive res, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, 
                   color: Colors.green[600], 
                   size: res.wp(4)),
              SizedBox(width: res.wp(2)),
              Expanded(
                child: Text(
                  'Payment has been completed successfully!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: res.hp(2)),

        // Payment amount
        if (pitch.requestedPaymentAmount != null)
          _buildDetailRow(
            res: res,
            theme: theme,
            icon: Icons.attach_money,
            label: 'Payment Amount',
            value: '\$${pitch.requestedPaymentAmount!.toStringAsFixed(2)}',
            valueColor: Colors.green[600],
          ),
      ],
    );
  }

  Widget _buildNoPaymentContent(BuildContext context, Responsive res, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, 
                   color: Colors.blue[600], 
                   size: res.wp(4)),
              SizedBox(width: res.wp(2)),
              Expanded(
                child: Text(
                  'Task completed! You can pay the fixer or wait for their payment request.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: res.hp(2)),

        // Original budget info
        _buildDetailRow(
          res: res,
          theme: theme,
          icon: Icons.account_balance_wallet,
          label: 'Agreed Budget',
          value: '\$${pitch.budget.toStringAsFixed(2)}',
          valueColor: Colors.blue[600],
        ),
        
        if (onInitiatePayment != null) ...[
          SizedBox(height: res.hp(2)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onInitiatePayment,
              icon: Icon(Icons.payment, size: res.wp(4)),
              label: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required Responsive res,
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiline = false,
  }) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: res.wp(4.5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: res.hp(0.5)),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (pitch.paymentStatus) {
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
    switch (pitch.paymentStatus) {
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

  Color _getIconBackgroundColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[100]!;
      case 'completed':
        return Colors.green[100]!;
      case 'declined':
        return Colors.red[100]!;
      default:
        return Colors.blue[100]!;
    }
  }

  IconData _getStatusIcon() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Icons.pending_actions;
      case 'completed':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      default:
        return Icons.payment;
    }
  }

  Color _getIconColor() {
    switch (pitch.paymentStatus) {
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

  String _getHeaderText() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return 'Payment Request Received';
      case 'completed':
        return 'Payment Completed';
      case 'declined':
        return 'Payment Request Declined';
      default:
        return 'Payment';
    }
  }

  String? _getSubHeaderText() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return 'Review and approve the payment request';
      case 'completed':
        return 'Payment has been processed successfully';
      case 'declined':
        return 'The payment request was declined';
      default:
        return 'Task completed - ready for payment';
    }
  }

  Color _getTextColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[700]!;
      case 'completed':
        return Colors.green[700]!;
      case 'declined':
        return Colors.red[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}