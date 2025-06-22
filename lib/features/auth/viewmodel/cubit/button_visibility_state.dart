import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonVisibilityState {
  final bool obscureText;

  const ButtonVisibilityState({required this.obscureText});

  ButtonVisibilityState copyWith({bool? obscureText}) {
    return ButtonVisibilityState(
      obscureText: obscureText ?? this.obscureText,
    );
  }
}


class ButtonVisibilityCubit extends Cubit<ButtonVisibilityState> {
  ButtonVisibilityCubit() : super(const ButtonVisibilityState(obscureText: true));

  void togglePasswordVisibility() {
    emit(state.copyWith(obscureText: !state.obscureText));
  }
}
