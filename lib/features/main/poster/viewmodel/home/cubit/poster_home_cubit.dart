import 'package:bloc/bloc.dart';
import 'package:quick_pitch_app/features/main/poster/repository/poster_repository.dart';

part 'poster_home_state.dart';

class PosterHomeCubit extends Cubit<PosterHomeState> {
  final PosterRepository repository;
  PosterHomeCubit(this.repository) : super(PosterHomeInitial());
 Future<void> fetchProfileImage()async{
   emit(PosterHomeLoading());
  try{
    final data = await repository.getUserDetails();
    if (data == null) throw Exception("User data not found");

    final imageUrl = data['profileImageUrl'] as String?;
    final name = data['name'] as String;
    final role = data['activeRole'] as String;

    // print('Fetched profileImageUrl: $imageUrl');
    // print('Name: $name | Role: $role');

    emit(PosterHomeLoaded(
      profileImageUrl: imageUrl,
      name: name,
      role: role,
    ));
  }catch(e){
    emit(PosterHomeError('Failed to fetch Load'));
  }
 }
}
