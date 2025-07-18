part of 'fixer_detail_cubit.dart';

class FixerDetailState extends Equatable {
  const FixerDetailState();

  @override
  List<Object> get props => [];
}

final class FixerDetailInitial extends FixerDetailState {}
final class FixerDetailLoading extends FixerDetailState{}
final class FixerDetailLoaded extends FixerDetailState{
 final UserProfileModel poster;
  const FixerDetailLoaded(this.poster);
  
  @override
List<Object> get props => [poster];

}


final class FixerDetailError extends FixerDetailState{
 final String message;
 const FixerDetailError(this.message);
}
