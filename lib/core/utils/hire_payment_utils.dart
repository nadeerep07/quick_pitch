import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

/// -------------------- UTILS -------------------- ///
class HirePaymentUtils {
  static Color getBackgroundColor(String status) {
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

  static Color getBorderColor(String status) {
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

  static Color getStatusColor(String status) {
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

  static IconData getStatusIcon(String status) {
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

  static String getStatusText(String status) {
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

  static double getDisplayAmount(HireRequest hireRequest) {
    if (hireRequest.paidAmount != null) {
      return hireRequest.paidAmount!;
    }
    return hireRequest.effectivePaymentAmount;
  }
}
