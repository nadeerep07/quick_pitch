// 📂 viewmodel/pitch_form/cubit/pitch_form_state.dart
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';
import 'pitch_form_cubit.dart';

class PitchFormState extends Equatable {
  final PaymentType paymentType;
  final String? timeline;
  final bool isSubmitting;
  final bool success;
  final String? error;
  final List<PitchModel> pitches; 
    final String selectedFilter;



  const PitchFormState({
    this.paymentType = PaymentType.fixed,
    this.timeline,
    this.isSubmitting = false,
    this.success = false,
    this.error,
    this.pitches = const [],
     this.selectedFilter = 'All',
  });

  PitchFormState copyWith({
    PaymentType? paymentType,
    String? timeline,
    bool? isSubmitting,
    bool? success,
    String? error,
    List<PitchModel>? pitches, //  new
      String? selectedFilter,
  }) {
    return PitchFormState(
      paymentType: paymentType ?? this.paymentType,
      timeline: timeline ?? this.timeline,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: error ?? this.error,
      pitches: pitches ?? this.pitches,
       selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
        paymentType,
        timeline,
        isSubmitting,
        success,
        error,
        pitches, //  new
        selectedFilter,
      ];
}
