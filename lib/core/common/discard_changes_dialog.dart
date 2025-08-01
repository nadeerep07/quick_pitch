import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20), // Added inset padding
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400), // Added max width constraint
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      size: 28,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded( // Added Expanded to prevent text overflow
                    child: Text(
                      "Unsaved Changes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Content text
              Text(
                "You have unsaved changes that will be lost if you leave this page. What would you like to do?",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons - now responsive
              Wrap( // Changed from Row to Wrap for better overflow handling
                alignment: WrapAlignment.end,
                spacing: 12,
                runSpacing: 12,
                children: [
                  // Keep editing button
                  SizedBox( // Constrained button width
                    width: 140, // Fixed width for consistency
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: theme.dividerColor,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Keep Editing"),
                    ),
                  ),
                  
                  // Discard button
                  SizedBox( // Constrained button width
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.red.shade700 : Colors.red.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Discard Changes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}