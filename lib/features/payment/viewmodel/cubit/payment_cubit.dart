import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentState {
  final bool isProcessing;
  final String? selectedReason;

  PaymentState({this.isProcessing = false, this.selectedReason});

  PaymentState copyWith({bool? isProcessing, String? selectedReason}) {
    return PaymentState(
      isProcessing: isProcessing ?? this.isProcessing,
      selectedReason: selectedReason ?? this.selectedReason,
    );
  }
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentState());

  void startProcessing() => emit(state.copyWith(isProcessing: true));
  void stopProcessing() => emit(state.copyWith(isProcessing: false));
  void selectReason(String? reason) =>
      emit(state.copyWith(selectedReason: reason));
}
