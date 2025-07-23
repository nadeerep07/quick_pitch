import 'package:bloc/bloc.dart';


class SectionFilterCubit extends Cubit<Set<String>> {
  SectionFilterCubit() : super({});
    void toggleFilter(String filter) {
    final newFilters = Set<String>.from(state);
    if (newFilters.contains(filter)) {
      newFilters.remove(filter);
    } else {
      newFilters.add(filter);
    }
    emit(newFilters);
  }

  void clearFilters() => emit({});
}
