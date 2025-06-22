part of 'onboarding_bloc.dart';


 class OnboardingState {
  final int currentIndex;
  const OnboardingState({required this.currentIndex});

  OnboardingState copyWith({int? currentIndex}) {
    return OnboardingState(currentIndex: currentIndex ?? this.currentIndex);
  }
}


