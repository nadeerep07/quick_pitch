part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

class OnPageChanged extends OnboardingEvent {
  final int index;

  OnPageChanged(this.index);
}

class NextPageTapped extends OnboardingEvent{}