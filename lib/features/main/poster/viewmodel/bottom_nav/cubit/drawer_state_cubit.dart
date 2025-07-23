import 'package:bloc/bloc.dart';


class DrawerStateCubit extends Cubit<bool> {
  DrawerStateCubit() : super(false);

  void setDrawerState(bool isOpen) => emit(isOpen);
}
