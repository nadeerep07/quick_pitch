import 'package:flutter/material.dart';

class ExploreSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ExploreSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search fixers, skills, or works...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
