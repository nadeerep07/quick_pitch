// submission_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionCubit extends Cubit<bool> {
  SubmissionCubit() : super(false);

  void start() => emit(true);
  void stop() => emit(false);
}
