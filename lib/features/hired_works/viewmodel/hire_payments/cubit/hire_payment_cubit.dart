import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/payment/service/hire_payment_services.dart';

part 'hire_payment_state.dart';

class HirePaymentCubit extends Cubit<HirePaymentState> {
  final HirePaymentService _hirePaymentService;

  HirePaymentCubit(this._hirePaymentService) : super(HirePaymentInitial());

  Future<void> completePayment({
    required String hireRequestId,
    required double amount,
    required String transactionId,
  }) async {
    emit(HirePaymentProcessing());
    try {
      await _hirePaymentService.markPaymentCompleted(
        hireRequestId: hireRequestId,
        paidAmount: amount,
        transactionId: transactionId,
      );
      emit(HirePaymentSuccess(transactionId: transactionId, amount: amount));
    } catch (e) {
      emit(HirePaymentFailure("Payment processed but failed to update status: $e"));
    }
  }

  Future<void> declinePayment({
    required String hireRequestId,
    required String reason,
  }) async {
    emit(HirePaymentProcessing());
    try {
      await _hirePaymentService.declinePaymentRequest(
        hireRequestId: hireRequestId,
        reason: reason,
      );
      emit(HirePaymentDeclined(reason: reason));
    } catch (e) {
      emit(HirePaymentFailure("Error declining payment: $e"));
    }
  }
}
