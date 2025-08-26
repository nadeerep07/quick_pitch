import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/components/fixer_pitch_detail_item.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class FixerPitchDetailCompletionSection extends StatelessWidget {
  const FixerPitchDetailCompletionSection({
    super.key,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.currentPitch,
    this.onRequestPayment,
  });

  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final PitchModel currentPitch;
  final VoidCallback? onRequestPayment;

  bool get _canRequestPayment => 
      currentPitch.paymentStatus == null || 
      currentPitch.paymentStatus == 'pending_request' ||
      currentPitch.paymentStatus == 'rejected';

  bool get _paymentRequested => 
      currentPitch.paymentStatus == 'payment_requested' ||
      currentPitch.paymentStatus == 'processing';

  bool get _paymentCompleted => 
      currentPitch.paymentStatus == 'completed' ||
      currentPitch.paymentStatus == 'paid';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.green[100]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[400]),
                SizedBox(width: res.wp(3)),
                Text(
                  'Task Completed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),
            
            if (currentPitch.completionDate != null) ...[
              FixerPitchDetailItem(
                res: res, 
                icon: Icons.calendar_today, 
                label: 'Completed On', 
                value: DateFormat('MMM dd, yyyy').format(currentPitch.completionDate!), 
                theme: theme, 
                colorScheme: colorScheme
              ),
              SizedBox(height: res.hp(1)),
            ],
            
            if (currentPitch.completionNotes != null) ...[
              FixerPitchDetailItem(
                res: res, 
                icon: Icons.note, 
                label: 'Completion Notes', 
                value: currentPitch.completionNotes!, 
                theme: theme, 
                colorScheme: colorScheme
              ),
              SizedBox(height: res.hp(1.5)),
            ],

            // Payment Section
            _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.green[200]),
        SizedBox(height: res.hp(1)),
        
        // Payment Status Row
        Row(
          children: [
            Icon(
              _getPaymentStatusIcon(),
              color: _getPaymentStatusColor(),
              size: res.wp(5),
            ),
            SizedBox(width: res.wp(3)),
            Text(
              _getPaymentStatusText(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getPaymentStatusColor(),
              ),
            ),
          ],
        ),
        
        ...[
        SizedBox(height: res.hp(1)),
        FixerPitchDetailItem(
          res: res,
          icon: Icons.attach_money,
          label: 'Agreed Amount',
          value: '\$${currentPitch.budget!.toStringAsFixed(2)}',
          theme: theme,
          colorScheme: colorScheme,
        ),
      ],

        SizedBox(height: res.hp(1.5)),
        
        // Payment Action Button
        if (_canRequestPayment)
          _buildRequestPaymentButton(context)
        else if (_paymentRequested)
          _buildPaymentRequestedStatus(context)
        else if (_paymentCompleted)
          _buildPaymentCompletedStatus(context),
      ],
    );
  }

  Widget _buildRequestPaymentButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showPaymentRequestDialog(context),
        icon: Icon(Icons.payment, size: res.wp(5)),
        label: Text(
          'Request Payment',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRequestedStatus(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.orange[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              'Payment request sent. Waiting for client approval.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCompletedStatus(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: res.wp(5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Text(
              'Payment completed successfully!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentRequestDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController(
      text: currentPitch.budget.toStringAsFixed(2) ?? '',
    );
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the payment details for this completed task:',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: res.hp(2)),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: res.hp(1.5)),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Payment Notes (Optional)',
                    prefixIcon: Icon(Icons.note_alt),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Add any additional notes about the payment...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _handlePaymentRequest(
                    double.tryParse(amountController.text) ?? 0,
                    notesController.text.trim(),
                  );
                }
              },
              child: Text('Request Payment'),
            ),
          ],
        );
      },
    );
  }

  void _handlePaymentRequest(double amount, String notes) {
    // This would typically call your payment service/API
    if (onRequestPayment != null) {
      onRequestPayment!();
    }
    
    // You might want to show a success message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Payment request sent successfully!')),
    // );
  }

  IconData _getPaymentStatusIcon() {
    switch (currentPitch.paymentStatus) {
      case 'completed':
      case 'paid':
        return Icons.check_circle;
      case 'payment_requested':
      case 'processing':
        return Icons.schedule;
      case 'rejected':
        return Icons.error_outline;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentStatusColor() {
    switch (currentPitch.paymentStatus) {
      case 'completed':
      case 'paid':
        return Colors.green[600]!;
      case 'payment_requested':
      case 'processing':
        return Colors.orange[600]!;
      case 'rejected':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getPaymentStatusText() {
    switch (currentPitch.paymentStatus) {
      case 'completed':
      case 'paid':
        return 'Payment Completed';
      case 'payment_requested':
        return 'Payment Requested';
      case 'processing':
        return 'Payment Processing';
      case 'rejected':
        return 'Payment Request Rejected';
      default:
        return 'Payment Pending';
    }
  }
}