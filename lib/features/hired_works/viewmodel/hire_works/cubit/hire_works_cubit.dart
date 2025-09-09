import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';

class HiredWorksState {
  final String? currentUserId;
  final String userName;
  final String userPhone;
  final int currentTabIndex;
  final bool forceRefresh;
  final String? errorMessage;

  HiredWorksState({
    required this.currentUserId,
    required this.userName,
    required this.userPhone,
    required this.currentTabIndex,
    required this.forceRefresh,
    required this.errorMessage,
  });

  factory HiredWorksState.initial() {
    return HiredWorksState(
      currentUserId: null,
      userName: '',
      userPhone: '',
      currentTabIndex: 0,
      forceRefresh: false,
      errorMessage: null,
    );
  }

  HiredWorksState copyWith({
    String? currentUserId,
    String? userName,
    String? userPhone,
    int? currentTabIndex,
    bool? forceRefresh,
    String? errorMessage,
  }) {
    return HiredWorksState(
      currentUserId: currentUserId ?? this.currentUserId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      forceRefresh: forceRefresh ?? this.forceRefresh,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class HiredWorksCubit extends Cubit<HiredWorksState> {
  final UserProfileService userProfileService;

  HiredWorksCubit({required this.userProfileService}) : super(HiredWorksState.initial());

  void init() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      emit(state.copyWith(currentUserId: currentUser.uid));
      loadUserInfo(currentUser.uid);
    }
  }

  Future<void> loadUserInfo(String userId) async {
    try {
      final userDoc = await userProfileService.getProfileDocument(userId, 'poster');
      final userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        emit(state.copyWith(
          userName: userData['name'] ?? 'User',
          userPhone: userData['phone'] ?? '',
        ));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error loading user info: $e'));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }

  Future<void> refresh() async {
    // Just trigger rebuild by emitting same state
    emit(state.copyWith(forceRefresh: !state.forceRefresh));
  }
}
