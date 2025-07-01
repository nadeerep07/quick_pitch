import 'package:bloc/bloc.dart';


class PosterBottomNavCubit extends Cubit<int> {
  PosterBottomNavCubit() : super(0);
  void changeTab(int index) => emit(index);
}
