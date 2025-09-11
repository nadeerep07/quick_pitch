// lib/features/settings/viewmodel/settings_viewmodel.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthServices _authService;
  
  SettingsViewModel({AuthServices? authService}) 
      : _authService = authService ?? AuthServices();

  // Email Change Logic
  Future<void> changeEmail(
    BuildContext context,
    String newEmail,
    String currentPassword,
  ) async {
    try {
      final user = _authService.currentUser;
      if (user?.email == null) throw Exception('User not found');

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update email
      await user.verifyBeforeUpdateEmail(newEmail);
      
      return; // Success - no exception thrown
    } catch (e) {
      rethrow;
    }
  }

  // Password Change Logic
  Future<void> changePassword(
    BuildContext context,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = _authService.currentUser;
      if (user?.email == null) throw Exception('User not found');

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  // Account Deletion Logic
  Future<void> deleteAccount(
    BuildContext context,
    String password,
  ) async {
    try {
      final user = _authService.currentUser;
      if (user?.email == null) throw Exception('User not found');

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Delete account
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Logout Logic
  Future<void> logout(BuildContext context) async {
    try {
      // Clear state
      context.read<DrawerStateCubit>().setDrawerState(false);
      context.read<PosterBottomNavCubit>().changeTab(0);
      context.read<FixerProfileCubit>().clear();

      // Logout
      await _authService.logout();
    } catch (e) {
      rethrow;
    }
  }

  // Switch Role Logic
  void switchRole(BuildContext context) {
    context.read<DrawerStateCubit>().setDrawerState(false);
    context.read<RoleSwitchCubit>().switchRole();
  }

  // Navigation Logic
  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  // Error Message Helper
  String getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
          return 'The password you entered is incorrect. Please try again.';
        case 'invalid-credential':
        case 'credential-already-in-use':
          return 'The supplied credential is malformed or has expired. Please check your password and try again.';
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'email-already-in-use':
          return 'This email address is already in use by another account.';
        case 'weak-password':
          return 'The password is too weak. Please choose a stronger password.';
        case 'requires-recent-login':
          return 'For security reasons, please sign out and sign in again before making this change.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please contact support.';
        default:
          return 'An error occurred: ${error.message ?? error.code}';
      }
    }
    return 'An unexpected error occurred: ${error.toString()}';
  }
}