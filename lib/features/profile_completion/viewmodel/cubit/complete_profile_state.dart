part of 'complete_profile_cubit.dart';

class CompleteProfileState {}

final class CompleteProfileInitial extends CompleteProfileState {}

final class CompleteProfileLoading extends CompleteProfileState {}

final class CompleteProfileSuccess extends CompleteProfileState {}

final class CompleteProfileError extends CompleteProfileState {
  final String message;
  CompleteProfileError(this.message);
}
final class CompleteProfileSkillUpdated extends CompleteProfileState {
  final List<String> selectedSkills;
  CompleteProfileSkillUpdated(this.selectedSkills);
}
final class SkillSelectionUpdated extends CompleteProfileState {
  final List<String> selectedSkills;

  SkillSelectionUpdated(this.selectedSkills);
}
final class SkillSearchUpdated extends CompleteProfileState {}

final class CompleteProfileLoaded extends CompleteProfileState{}

class PlaceSuggestionsUpdated extends CompleteProfileState {
  final List<String> suggestions;
  PlaceSuggestionsUpdated(this.suggestions);
}

