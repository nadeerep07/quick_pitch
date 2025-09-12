import 'package:flutter/material.dart';

class ReviewActionButtons extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final dynamic existingReview;

  const ReviewActionButtons({
    super.key,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
    this.existingReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: isSubmitting ? null : onCancel,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(existingReview != null ? 'Update' : 'Submit'),
          ),
        ),
      ],
    );
  }
}
