import 'package:flutter/material.dart';

class PlaceholderContent extends StatelessWidget {
  final String message;

  const PlaceholderContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
