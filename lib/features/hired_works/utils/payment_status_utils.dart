import 'package:flutter/material.dart';

/// -------------------- PAYMENT STATUS UTILS -------------------- ///
class PaymentStatusUtils {
  static Color backgroundColor(String status) {
    switch (status) {
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

  static Color borderColor(String status) {
    switch (status) {
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

  static Color statusColor(String status) {
    switch (status) {
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

  static IconData statusIcon(String status) {
    switch (status) {
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

  static String statusText(String status) {
    switch (status) {
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
}

