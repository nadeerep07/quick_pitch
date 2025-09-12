import 'package:flutter/material.dart';

class CommentInputField extends StatelessWidget {
  final String comment;
  final ValueChanged<String> onChanged;

  const CommentInputField({
    super.key,
    required this.comment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      maxLines: 4,
      maxLength: 500,
      onChanged: onChanged,
      controller: TextEditingController(text: comment),
      decoration: InputDecoration(
        hintText: 'Share your experience...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
      ),
    );
  }
}