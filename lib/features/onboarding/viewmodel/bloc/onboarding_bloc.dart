import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState(currentIndex: 0)) {
    on<OnPageChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
    on<NextPageTapped>((event, emit) {
    try{
      if (state.currentIndex < 2) {
        emit(state.copyWith(currentIndex: state.currentIndex + 1));
      } else {
       
      }
    } catch (e) {
     
     // print('Error navigating to next page: $e');
    }
    });
  }
}
