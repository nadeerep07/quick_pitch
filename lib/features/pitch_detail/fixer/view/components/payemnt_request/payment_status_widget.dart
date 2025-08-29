import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentStatusSection extends StatelessWidget {
  final PitchModel pitch;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback? onRequestPayment;
  final VoidCallback? onCancelPaymentRequest;

  const PaymentStatusSection({
    super.key,
    required this.pitch,
    required this.res,
    required this.theme,
    required this.colorScheme,
    this.onRequestPayment,
    this.onCancelPaymentRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (pitch.status != 'completed') {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
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
            _buildHeader(),
            SizedBox(height: res.hp(1.5)),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(_getStatusIcon(), color: _getIconColor()),
        SizedBox(width: res.wp(3)),
        Text(
          _getHeaderText(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: _getTextColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (pitch.paymentStatus) {
      case 'requested':
        return _buildPaymentRequestedContent(context);
      case 'completed':
        return _buildPaymentCompletedContent();
      default:
        return _buildNoPaymentContent(context);
    }
  }

  Widget _buildPaymentRequestedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pitch.requestedPaymentAmount != null) ...[
          FixerPitchDetailItem(
            res: res,
            icon: Icons.attach_money,
            label: 'Requested Amount',
            value: '\$${pitch.requestedPaymentAmount!.toStringAsFixed(2)}',
            theme: theme,
            colorScheme: colorScheme,
          ),
          SizedBox(height: res.hp(1)),
        ],
        
        if (pitch.paymentRequestedAt != null) ...[
          FixerPitchDetailItem(
            res: res,
            icon: Icons.schedule,
            label: 'Requested On',
            value: DateFormat('MMM dd, yyyy').format(pitch.paymentRequestedAt!),
            theme: theme,
            colorScheme: colorScheme,
          ),
          SizedBox(height: res.hp(1)),
        ],

        if (pitch.paymentRequestNotes != null && pitch.paymentRequestNotes!.isNotEmpty) ...[
          FixerPitchDetailItem(
            res: res,
            icon: Icons.note,
            label: 'Notes',
            value: pitch.paymentRequestNotes!,
            theme: theme,
            colorScheme: colorScheme,
          ),
          SizedBox(height: res.hp(1.5)),
        ],

        // Cancel payment request button
        if (onCancelPaymentRequest != null) ...[
          SizedBox(height: res.hp(1)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCancelPaymentRequest,
              icon: Icon(Icons.cancel_outlined, size: res.wp(4)),
              label: Text('Cancel Payment Request'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange[700],
                side: BorderSide(color: Colors.orange[300]!),
                padding: EdgeInsets.symmetric(vertical: res.hp(1.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentCompletedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pitch.requestedPaymentAmount != null) ...[
          FixerPitchDetailItem(
            res: res,
            icon: Icons.attach_money,
            label: 'Payment Amount',
            value: '\$${pitch.requestedPaymentAmount!.toStringAsFixed(2)}',
            theme: theme,
            colorScheme: colorScheme,
          ),
          SizedBox(height: res.hp(1)),
        ],

        FixerPitchDetailItem(
          res: res,
          icon: Icons.check_circle,
          label: 'Status',
          value: 'Payment Completed',
          theme: theme,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildNoPaymentContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task completed successfully! You can now request payment from the poster.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        
        if (onRequestPayment != null) ...[
          SizedBox(height: res.hp(2)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRequestPayment,
              icon: Icon(Icons.payment, size: res.wp(4)),
              label: Text('Request Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Helper methods for styling based on payment status
  Color _getBackgroundColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[50]!;
      case 'completed':
        return Colors.green[50]!;
      default:
        return Colors.blue[50]!;
    }
  }

  Color _getBorderColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[100]!;
      case 'completed':
        return Colors.green[100]!;
      default:
        return Colors.blue[100]!;
    }
  }

  IconData _getStatusIcon() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Icons.schedule;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.payment;
    }
  }

  Color _getIconColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[400]!;
      case 'completed':
        return Colors.green[400]!;
      default:
        return Colors.blue[400]!;
    }
  }

  String _getHeaderText() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return 'Payment Requested';
      case 'completed':
        return 'Payment Completed';
      default:
        return 'Payment';
    }
  }

  Color _getTextColor() {
    switch (pitch.paymentStatus) {
      case 'requested':
        return Colors.orange[600]!;
      case 'completed':
        return Colors.green[600]!;
      default:
        return Colors.blue[600]!;
    }
  }
}