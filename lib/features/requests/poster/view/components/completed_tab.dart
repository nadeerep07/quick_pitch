import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/placeholder_content.dart';
import 'package:quick_pitch_app/features/requests/poster/view/screens/poster_requests_screen.dart';

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderContent(message: "Completed tasks will show here.");
  }
}
