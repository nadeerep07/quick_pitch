import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PaymentModel {
  final String id;
  final String taskId;
  final String posterName;
  final String? posterImage;
  final double amount;
  final DateTime paidAt;
  final String transactionId;
  final String status;
  final String paymentType; // 'pitch' or 'hire_request'

  PaymentModel({
    required this.id,
    required this.taskId,
    required this.posterName,
    this.posterImage,
    required this.amount,
    required this.paidAt,
    required this.transactionId,
    required this.status,
    this.paymentType = 'pitch', // default to pitch for backward compatibility
  });

  factory PaymentModel.fromPitch(PitchModel pitch) {
    return PaymentModel(
      id: pitch.id,
      taskId: pitch.taskId,
      posterName: pitch.posterName ?? 'Unknown Poster',
      posterImage: pitch.posterImage,
      amount: pitch.requestedPaymentAmount ?? pitch.budget,
      paidAt: pitch.paymentCompletedAt ?? DateTime.now(),
      transactionId: pitch.transactionId ?? '',
      status: pitch.paymentStatus ?? 'completed',
      paymentType: 'pitch',
    );
  }

  bool get isPitchPayment => paymentType == 'pitch';
  bool get isHireRequestPayment => paymentType == 'hire_request';
}