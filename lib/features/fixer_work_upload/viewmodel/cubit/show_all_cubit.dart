import 'package:flutter_bloc/flutter_bloc.dart';

class ShowAllCubit extends Cubit<bool> {
  ShowAllCubit() : super(false);

  void toggle() => emit(!state);
}
