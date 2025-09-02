import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';
import 'package:quick_pitch_app/features/user_profile/poster/viewmodel/cubit/poster_profile_cubit.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = AuthServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: .05),
              theme.colorScheme.secondary.withValues(alpha: .02),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Account Management Section
            _buildSectionHeader('Account Management', theme),
            const SizedBox(height: 8),
            _buildAccountCard(context, theme, authService),

            const SizedBox(height: 24),

            // App Settings Section
            _buildSectionHeader('App Settings', theme),
            const SizedBox(height: 8),
            _buildAppSettingsCard(context, theme),

            const SizedBox(height: 24),

            // Role & Session Section
            _buildSectionHeader('Role & Session', theme),
            const SizedBox(height: 8),
            _buildRoleSessionCard(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    ThemeData theme,
    AuthServices authService,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingsItem(
            context: context,
            icon: Icons.email_outlined,
            title: 'Change Email',
            subtitle: 'Update your email address',
            onTap: () => _showChangeEmailDialog(context, authService),
            theme: theme,
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () => _showChangePasswordDialog(context, authService),
            theme: theme,
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsItem(
            context: context,
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () => _showDeleteAccountDialog(context, authService),
            theme: theme,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingsItem(
            context: context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              // TODO: Navigate to notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon'),
                ),
              );
            },
            theme: theme,
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsItem(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            subtitle: 'Privacy and data settings',
            onTap: () {
              // TODO: Navigate to privacy settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon')),
              );
            },
            theme: theme,
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsItem(
            context: context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              // TODO: Navigate to help center
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help center coming soon')),
              );
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSessionCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingsItem(
            context: context,
            icon: Icons.sync_alt,
            title: 'Switch Role',
            subtitle: 'Switch between poster and fixer',
            onTap: () => _showSwitchRoleDialog(context),
            theme: theme,
            isHighlighted: true,
          ),
          const Divider(height: 1, indent: 56),
          _buildSettingsItem(
            context: context,
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            onTap: () => _showLogoutDialog(context),
            theme: theme,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isHighlighted = false,
    bool isDestructive = false,
  }) {
    Color? iconColor;
    Color? titleColor;

    if (isDestructive) {
      iconColor = theme.colorScheme.error;
      titleColor = theme.colorScheme.error;
    } else if (isHighlighted) {
      iconColor = theme.colorScheme.primary;
      titleColor = theme.colorScheme.primary;
    }

    return ListTile(
      leading: Icon(icon, color: iconColor ?? theme.iconTheme.color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
          color: titleColor ?? theme.textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.iconTheme.color?.withValues(alpha: 0.6),
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
    );
  }

  void _showChangeEmailDialog(BuildContext context, AuthServices authService) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Email'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Close the form dialog first
                Navigator.pop(dialogContext);
                
                // Show loading dialog
                _showLoadingDialog(context);

                try {
                  final user = authService.currentUser;
                  if (user != null && user.email != null) {
                    // Re-authenticate user first
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: passwordController.text,
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Update email
                    await user.verifyBeforeUpdateEmail(emailController.text);
                    
                    // Close loading dialog if context is still mounted
                    if (context.mounted) {
                      Navigator.pop(context);
                      _showSuccessDialog(
                        context,
                        'Verification email sent to ${emailController.text}. Please verify to complete the email change.',
                      );
                    }
                  }
                } catch (e) {
                  // Close loading dialog if context is still mounted
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showErrorDialog(
                      context,
                      _getFirebaseErrorMessage(e),
                    );
                  }
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthServices authService) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Close the form dialog first
                Navigator.pop(dialogContext);
                
                // Show loading dialog
                _showLoadingDialog(context);

                try {
                  final user = authService.currentUser;
                  if (user != null && user.email != null) {
                    // Re-authenticate user first
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: currentPasswordController.text,
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Update password
                    await user.updatePassword(newPasswordController.text);

                    // Close loading dialog if context is still mounted
                    if (context.mounted) {
                      Navigator.pop(context);
                      _showSuccessDialog(
                        context,
                        'Password updated successfully',
                      );
                    }
                  }
                } catch (e) {
                  // Close loading dialog if context is still mounted
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showErrorDialog(
                      context,
                      _getFirebaseErrorMessage(e),
                    );
                  }
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthServices authService) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Delete Account'),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Enter your password to confirm',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password to confirm deletion';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Close the form dialog first
                Navigator.pop(dialogContext);
                
                // Show loading dialog
                _showLoadingDialog(context);

                try {
                  final user = authService.currentUser;
                  if (user != null && user.email != null) {
                    // Re-authenticate user first
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: passwordController.text,
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Delete account
                    await user.delete();

                    // Close loading dialog if context is still mounted
                    if (context.mounted) {
                      Navigator.pop(context);
                      
                      // Navigate to login screen
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  }
                } catch (e) {
                  // Close loading dialog if context is still mounted
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showErrorDialog(
                      context,
                      _getFirebaseErrorMessage(e),
                    );
                  }
                }
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showSwitchRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: "Switch Role",
        message: "Do you want to switch to the other role?",
        icon: Icons.sync_alt,
        iconColor: AppColors.primaryColor,
        onConfirm: () {
          Navigator.pop(dialogContext); // Close dialog first
          context.read<DrawerStateCubit>().setDrawerState(false);
          context.read<RoleSwitchCubit>().switchRole();
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: "Sign Out",
        message: "Are you sure you want to sign out?",
        icon: Icons.logout,
        iconColor: Theme.of(context).colorScheme.error,
        onConfirm: () async {
          Navigator.pop(dialogContext); // Close dialog
          
          // Show loading dialog
          _showLoadingDialog(context);

          try {
            // Clear state
            context.read<DrawerStateCubit>().setDrawerState(false);
            context.read<PosterBottomNavCubit>().changeTab(0);
            context.read<FixerProfileCubit>().clear();

            // Logout
            await AuthServices().logout();

            // Close loading dialog if context is still mounted
            if (context.mounted) {
              Navigator.pop(context);
              
              // Navigate to login
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login, 
                (route) => false
              );
            }
          } catch (e) {
            // Close loading dialog if context is still mounted
            if (context.mounted) {
              Navigator.pop(context);
              _showErrorDialog(
                context,
                'Failed to sign out: ${e.toString()}',
              );
            }
          }
        },
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper method to get user-friendly Firebase error messages
  String _getFirebaseErrorMessage(dynamic error) {
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