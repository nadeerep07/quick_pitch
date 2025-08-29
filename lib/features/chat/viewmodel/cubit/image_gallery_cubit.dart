import 'package:flutter_bloc/flutter_bloc.dart';

class ImageGalleryCubit extends Cubit<int> {
  ImageGalleryCubit() : super(0);

  void updateIndex(int index) => emit(index);
}
