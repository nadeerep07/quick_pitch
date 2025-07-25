import 'package:flutter/material.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'v1.0.0 • Quick Pitch App',
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
