// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

// part 'poster_explore_map_state.dart';

// class PosterExploreMapCubit extends Cubit<PosterExploreMapState> {
//   PosterExploreMapCubit() : super(PosterExploreMapState.initial());

//   void setMapController(GoogleMapController controller) {
//     emit(state.copyWith(controller: controller));
//   }

//   Future<void> loadMarkers({
//     required List<UserProfileModel> fixers,
//     Position? posterLocation,
//     required Function(UserProfileModel fixer) onFixerTap,
//   }) async {
//     emit(state.copyWith(isLoading: true));

//     final markers = await MarkerHelper.generateMarkers(
//       fixers: fixers,
//       posterLocation: posterLocation,
//       onFixerTap: onFixerTap,
//     );

//     emit(state.copyWith(markers: markers, isLoading: false));
//   }
// }
