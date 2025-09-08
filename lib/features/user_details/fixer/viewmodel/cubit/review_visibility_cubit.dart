import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewVisibilityCubit extends Cubit<bool> {
  ReviewVisibilityCubit() : super(false); // initially hidden

  void toggle() => emit(!state);

  void show() => emit(true);

  void hide() => emit(false);
}
