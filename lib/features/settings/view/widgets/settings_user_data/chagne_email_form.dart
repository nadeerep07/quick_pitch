import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/model/email_form_data.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/Input_filed.dart';

class ChangeEmailForm extends StatefulWidget {
  final Function(EmailFormData) onSubmit;

  const ChangeEmailForm({super.key, required this.onSubmit});

  @override
  State<ChangeEmailForm> createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Email'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              controller: _emailController,
              label: 'New Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your new email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _passwordController,
              label: 'Current Password',
              obscure: true,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your password' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(EmailFormData(
                newEmail: _emailController.text,
                currentPassword: _passwordController.text,
              ));
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}


