part of 'hire_payment_cubit.dart';

abstract class HirePaymentState {}

class HirePaymentInitial extends HirePaymentState {}

class HirePaymentProcessing extends HirePaymentState {}

class HirePaymentSuccess extends HirePaymentState {
  final String transactionId;
  final double amount;
  HirePaymentSuccess({required this.transactionId, required this.amount});
}

class HirePaymentDeclined extends HirePaymentState {
  final String reason;
  HirePaymentDeclined({required this.reason});
}

class HirePaymentFailure extends HirePaymentState {
  final String message;
  HirePaymentFailure(this.message);
}
