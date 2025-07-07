import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Discard Changes?"),
      content: const Text("You have unsaved changes. Do you want to discard them or keep the draft?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Stay
          child: const Text("Stay"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // Discard
          child: const Text("Discard", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
