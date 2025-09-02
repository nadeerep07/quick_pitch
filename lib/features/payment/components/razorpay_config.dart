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
