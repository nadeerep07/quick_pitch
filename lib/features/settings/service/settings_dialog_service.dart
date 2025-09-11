// lib/features/settings/services/settings_dialog_service.dart
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/model/email_form_data.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/Input_filed.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/message_dialog.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_section_widget.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_user_data/chagne_email_form.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_user_data/change_password_dialog.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_user_data/delete_account_dialog.dart';


class SettingsDialogService {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => MessageDialog(
        title: 'Success',
        message: message,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        onPressed: () => Navigator.pop(dialogContext),
      ),
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => MessageDialog(
        title: 'Error',
        message: message,
        icon: Icons.error,
        iconColor: Theme.of(context).colorScheme.error,
        onPressed: () => Navigator.pop(dialogContext),
      ),
    );
  }

  static void showChangeEmailDialog(
    BuildContext context,
    Function(EmailFormData) onSubmit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeEmailForm(
        onSubmit: (data) {
          Navigator.pop(dialogContext);
          onSubmit(data);
        },
      ),
    );
  }

  static void showChangePasswordDialog(
    BuildContext context,
    Function(PasswordFormData) onSubmit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangePasswordForm(
        onSubmit: (data) {
          Navigator.pop(dialogContext);
          onSubmit(data);
        },
      ),
    );
  }

  static void showDeleteAccountDialog(
    BuildContext context,
    Function(String) onSubmit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteAccountForm(
        onSubmit: (password) {
          Navigator.pop(dialogContext);
          onSubmit(password);
        },
      ),
    );
  }

  static void closeDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}