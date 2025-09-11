import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/model/email_form_data.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/Input_filed.dart';

class ChangePasswordForm extends StatefulWidget {
  final Function(PasswordFormData) onSubmit;

  const ChangePasswordForm({super.key, required this.onSubmit});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              controller: _currentPasswordController,
              label: 'Current Password',
              obscure: true,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your password' : null,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _newPasswordController,
              label: 'New Password',
              obscure: true,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a new password';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscure: true,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm password';
                if (value != _newPasswordController.text) return 'Passwords do not match';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(PasswordFormData(
                currentPassword: _currentPasswordController.text,
                newPassword: _newPasswordController.text,
                confirmPassword: _confirmPasswordController.text,
              ));
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}


