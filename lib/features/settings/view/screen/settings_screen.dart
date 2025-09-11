
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_pitch_app/features/settings/view/widgets/settings_content.dart';
import 'package:quick_pitch_app/features/settings/viewmodel/settings_view_model.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: const SettingsContent(),
    );
  }
}

// lib/features/settings/view/widgets/settings_content.dart
