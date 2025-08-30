import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final PitchModel pitch;
  final Function(String paymentId, double amount) onPaymentSuccess;
  final Function(String error) onPaymentError;
  final bool isFromRequest; // true if approving a request, false if initiating payment
  final String razorpayKeyId; // Your Razorpay key ID
  final String userPhone;
  final String userName;

  const PaymentConfirmationDialog({
    super.key,
    required this.pitch,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.razorpayKeyId,
    required this.userPhone,
    required this.userName,
    this.isFromRequest = false,
  });

  @override
  State<PaymentConfirmationDialog> createState() => _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _isProcessing = false;
    });
    Navigator.of(context).pop();
    final paymentAmount = widget.isFromRequest 
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;
    widget.onPaymentSuccess(response.paymentId!, paymentAmount);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessing = false;
    });
    widget.onPaymentError(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _isProcessing = false;
    });
    widget.onPaymentError('External wallet payment cancelled');
  }

  void _initiatePayment() {
    setState(() {
      _isProcessing = true;
    });

    final paymentAmount = widget.isFromRequest 
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;

    // Convert amount to paise (Razorpay uses paise as the smallest unit)
    final amountInPaise = (paymentAmount * 100).toInt();

    var options = {
      'key': widget.razorpayKeyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'QuickPitch',
      'description': widget.isFromRequest 
          ? 'Payment for task:'
          : 'Task completion payment',
      'prefill': {
        'contact': widget.userPhone,
        'name': widget.userName,
      },
      'theme': {
        'color': '#4CAF50'
      },
      'notes': {
        'pitch_id': widget.pitch.id,
        'payment_type': widget.isFromRequest ? 'request_approval' : 'task_payment',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      widget.onPaymentError('Error opening payment gateway: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final paymentAmount = widget.isFromRequest 
        ? (widget.pitch.requestedPaymentAmount ?? widget.pitch.budget)
        : widget.pitch.budget;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Container(
              padding: EdgeInsets.all(res.wp(4)),
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payment,
                color: Colors.green[600],
                size: res.wp(8),
              ),
            ),
            SizedBox(height: res.hp(2)),

            // Title
            Text(
              widget.isFromRequest ? 'Approve Payment Request' : 'Confirm Payment',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(1)),

            // Description
            Text(
              widget.isFromRequest 
                  ? 'You are about to approve and process the payment request via Razorpay.'
                  : 'You are about to pay the fixer for the completed task via Razorpay.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(3)),

            // Payment details card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(res.wp(4)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount:',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${paymentAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gateway:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/razorpay_logo.png', // Add Razorpay logo to assets
                            height: res.hp(2),
                            errorBuilder: (context, error, stackTrace) => 
                                Text('Razorpay', style: theme.textTheme.bodySmall),
                          ),
                          SizedBox(width: res.wp(1)),
                          Text(
                            'Secure Payment',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.isFromRequest && widget.pitch.paymentRequestNotes != null && widget.pitch.paymentRequestNotes!.isNotEmpty) ...[
                    SizedBox(height: res.hp(1.5)),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: res.hp(1)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Notes: ${widget.pitch.paymentRequestNotes!}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: res.hp(3)),

            // Security info
            Container(
              padding: EdgeInsets.all(res.wp(3)),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, 
                       color: Colors.blue[700], 
                       size: res.wp(4)),
                  SizedBox(width: res.wp(2)),
                  Expanded(
                    child: Text(
                      'Payments are processed securely via Razorpay. Your card details are never stored.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: res.hp(3)),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _initiatePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? SizedBox(
                            height: res.hp(2),
                            width: res.hp(2),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(widget.isFromRequest ? 'Approve & Pay' : 'Pay Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentDeclineDialog extends StatefulWidget {
  final PitchModel pitch;
  final Function(String reason) onDeclinePayment;

  const PaymentDeclineDialog({
    super.key,
    required this.pitch,
    required this.onDeclinePayment,
  });

  @override
  State<PaymentDeclineDialog> createState() => _PaymentDeclineDialogState();
}

class _PaymentDeclineDialogState extends State<PaymentDeclineDialog> {
  final _reasonController = TextEditingController();
  String? _selectedReason;

  final List<String> _predefinedReasons = [
    'Amount is higher than agreed budget',
    'Task was not completed as specified',
    'Work quality does not meet requirements',
    'Other (specify below)',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.cancel, color: Colors.red[500], size: res.wp(6)),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: Text(
                    'Decline Payment Request',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(2)),

            // Reason selection
            Text(
              'Please select a reason for declining:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: res.hp(1.5)),

            ..._predefinedReasons.map((reason) => RadioListTile<String>(
              title: Text(
                reason,
                style: theme.textTheme.bodyMedium,
              ),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) => setState(() => _selectedReason = value),
              contentPadding: EdgeInsets.zero,
            )),

            // Additional notes field
            if (_selectedReason == 'Other (specify below)') ...[
              SizedBox(height: res.hp(1)),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Please specify the reason...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            SizedBox(height: res.hp(3)),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason != null ? () {
                      final reason = _selectedReason == 'Other (specify below)'
                          ? _reasonController.text.trim()
                          : _selectedReason!;
                      
                      if (reason.isNotEmpty) {
                        Navigator.of(context).pop();
                        widget.onDeclinePayment(reason);
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for payment configuration
class RazorpayConfig {
  static const String keyId = 'rzp_test_RBVpctnSopqcnF'; // Replace with your actual key
  static const String keySecret = '8WZXJWqURb5cQP8rON82ccIV'; // Keep this secure, don't expose in frontend
  
  // Payment options builder
  static Map<String, dynamic> buildPaymentOptions({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    required String description,
    Map<String, dynamic>? notes,
  }) {
    final amountInPaise = (amount * 100).toInt();
    
    return {
      'key': keyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'QuickPitch',
      'description': description,
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
        'name': userName,
      },
      'theme': {
        'color': '#4CAF50'
      },
      'notes': notes ?? {},
      'retry': {
        'enabled': true,
        'max_count': 3,
      },
      'timeout': 300, // 5 minutes
      'send_sms_hash': true,
    };
  }
}

// Usage example widget showing how to implement the payment dialogs
class PaymentDialogExample extends StatelessWidget {
  final PitchModel pitch;

  const PaymentDialogExample({
    super.key,
    required this.pitch,
  });

  void _showPaymentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        pitch: pitch,
        razorpayKeyId: RazorpayConfig.keyId,
     //   userEmail: 'user@example.com', // Get from your user model
        userPhone: '+919876543210', // Get from your user model
        userName: 'John Doe', // Get from your user model
        isFromRequest: true, // or false based on your use case
        onPaymentSuccess: (paymentId, amount) {
          // Handle successful payment
          print('Payment successful: $paymentId, Amount: $amount');
          // Update your backend, show success message, etc.
          _showPaymentSuccessDialog(context, paymentId, amount);
        },
        onPaymentError: (error) {
          // Handle payment error
          print('Payment error: $error');
          _showPaymentErrorDialog(context, error);
        },
      ),
    );
  }

  void _showPaymentDecline(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PaymentDeclineDialog(
        pitch: pitch,
        onDeclinePayment: (reason) {
          // Handle payment decline
          print('Payment declined: $reason');
          // Update your backend, notify the fixer, etc.
        },
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, String paymentId, double amount) {
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

  void _showPaymentErrorDialog(BuildContext context, String error) {
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
              _showPaymentConfirmation(context);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showPaymentConfirmation(context),
              child: Text('Initiate Payment'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentDecline(context),
              child: Text('Decline Payment'),
            ),
          ],
        ),
      ),
    );
  }
}