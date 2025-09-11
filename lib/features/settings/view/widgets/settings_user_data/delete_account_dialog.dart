import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/Input_filed.dart';

class DeleteAccountForm extends StatefulWidget {
  final Function(String) onSubmit;

  const DeleteAccountForm({super.key, required this.onSubmit});

  @override
  State<DeleteAccountForm> createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: errorColor),
          const SizedBox(width: 8),
          const Text('Delete Account'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: errorColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _passwordController,
              label: 'Enter your password to confirm',
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
          style: ElevatedButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_passwordController.text);
            }
          },
          child: const Text('Delete Account'),
        ),
      ],
    );
  }
}
