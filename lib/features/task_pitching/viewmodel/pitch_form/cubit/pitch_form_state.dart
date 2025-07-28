// 📂 viewmodel/pitch_form/cubit/pitch_form_state.dart
import 'package:equatable/equatable.dart';
import 'pitch_form_cubit.dart';

class PitchFormState extends Equatable {
  final PaymentType paymentType;
  final String? timeline;
  final bool isSubmitting;
  final bool success;
  final String? error;

  const PitchFormState({
    this.paymentType = PaymentType.fixed,
    this.timeline,
    this.isSubmitting = false,
    this.success = false,
    this.error,
  });

  PitchFormState copyWith({
    PaymentType? paymentType,
    String? timeline,
    bool? isSubmitting,
    bool? success ,
    String? error,
  }) {
    return PitchFormState(
      paymentType: paymentType ?? this.paymentType,
      timeline: timeline ?? this.timeline,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: error,
    );
  }

  @override
  List<Object?> get props => [paymentType, timeline, isSubmitting, success, error];
}
