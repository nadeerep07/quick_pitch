import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentRequestState {
  final bool isLoading;
  const PaymentRequestState({this.isLoading = false});
}

class PaymentRequestCubit extends Cubit<PaymentRequestState> {
  PaymentRequestCubit() : super(const PaymentRequestState());

  void setLoading(bool loading) => emit(PaymentRequestState(isLoading: loading));
}
