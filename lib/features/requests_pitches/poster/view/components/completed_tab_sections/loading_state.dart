import 'package:flutter/material.dart';

/// --------------------
///  UI States
/// --------------------
class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
