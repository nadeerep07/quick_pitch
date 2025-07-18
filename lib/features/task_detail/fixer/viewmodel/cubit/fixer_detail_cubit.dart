import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

part 'fixer_detail_state.dart';

class FixerDetailCubit extends Cubit<FixerDetailState> {
  FixerDetailCubit() : super(FixerDetailInitial());

  Future<void> fetchPosterProfile(String posterId) async {
    emit(FixerDetailLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(posterId)
          .collection('roles')
          .doc('poster')
          .get();

      if (doc.exists) {
        final user = UserProfileModel.fromJson(doc.data()!);
        emit(FixerDetailLoaded(user));
      } else {
        emit(FixerDetailError("Poster profile not found"));
      }
    } catch (e) {
      emit(FixerDetailError("Failed to fetch poster profile: $e"));
    }
  }

  Future<void> launchMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        debugPrint("Could not launch Maps");
      }
    } catch (e) {
      debugPrint("Launch failed: $e");
    }
  }
}
