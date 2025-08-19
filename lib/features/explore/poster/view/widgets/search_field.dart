import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDarkMode;

  const SearchField({super.key, required this.controller, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            isDarkMode ? Colors.grey[800]!.withOpacity(0.6) : Colors.grey[50],
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: "Search skills...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
