import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_pitch_app/features/settings/model/email_form_data.dart';
import 'package:quick_pitch_app/features/settings/service/settings_dialog_service.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/account_managment_section.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/Input_filed.dart';
import 'package:quick_pitch_app/features/settings/viewmodel/settings_view_model.dart';
class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<SettingsViewModel>(context);

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
            AccountManagementSection(
              onChangeEmail: () => _handleChangeEmail(context, viewModel),
              onChangePassword: () => _handleChangePassword(context, viewModel),
              onDeleteAccount: () => _handleDeleteAccount(context, viewModel),
            ),
            const SizedBox(height: 24),
            const AppSettingsSection(),
            const SizedBox(height: 24),
            RoleSessionSection(
              onSwitchRole: () => viewModel.switchRole(context),
              onSignOut: () => _handleSignOut(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChangeEmail(BuildContext context, SettingsViewModel viewModel) {
    SettingsDialogService.showChangeEmailDialog(
      context,
      (EmailFormData data) async {
        SettingsDialogService.showLoadingDialog(context);
        try {
          await viewModel.changeEmail(context, data.newEmail, data.currentPassword);
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            SettingsDialogService.showSuccessDialog(
              context,
              'Verification email sent to ${data.newEmail}. Please verify to complete the email change.',
            );
          }
        } catch (e) {
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            SettingsDialogService.showErrorDialog(
              context,
              viewModel.getFirebaseErrorMessage(e),
            );
          }
        }
      },
    );
  }

  void _handleChangePassword(BuildContext context, SettingsViewModel viewModel) {
    SettingsDialogService.showChangePasswordDialog(
      context,
      (PasswordFormData data) async {
        SettingsDialogService.showLoadingDialog(context);
        try {
          await viewModel.changePassword(context, data.currentPassword, data.newPassword);
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            SettingsDialogService.showSuccessDialog(context, 'Password updated successfully');
          }
        } catch (e) {
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            SettingsDialogService.showErrorDialog(
              context,
              viewModel.getFirebaseErrorMessage(e),
            );
          }
        }
      },
    );
  }

  void _handleDeleteAccount(BuildContext context, SettingsViewModel viewModel) {
    SettingsDialogService.showDeleteAccountDialog(
      context,
      (String password) async {
        SettingsDialogService.showLoadingDialog(context);
        try {
          await viewModel.deleteAccount(context, password);
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            viewModel.navigateToLogin(context);
          }
        } catch (e) {
          if (context.mounted) {
            SettingsDialogService.closeDialog(context);
            SettingsDialogService.showErrorDialog(
              context,
              viewModel.getFirebaseErrorMessage(e),
            );
          }
        }
      },
    );
  }

  void _handleSignOut(BuildContext context, SettingsViewModel viewModel) async {
    SettingsDialogService.showLoadingDialog(context);
    try {
      await viewModel.logout(context);
      if (context.mounted) {
        SettingsDialogService.closeDialog(context);
        viewModel.navigateToLogin(context);
      }
    } catch (e) {
      if (context.mounted) {
        SettingsDialogService.closeDialog(context);
        SettingsDialogService.showErrorDialog(context, 'Failed to sign out: ${e.toString()}');
      }
    }
  }
}
