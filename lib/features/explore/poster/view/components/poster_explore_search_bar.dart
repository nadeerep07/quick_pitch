import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreSearchBar extends StatelessWidget {
  const PosterExploreSearchBar({
    super.key,
    required this.res,
    required this.theme,
  });

  final Responsive res;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Fixers or Skills...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[500],
        ),
        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: res.hp(1.5),
        ),
        constraints: BoxConstraints(
          maxHeight: res.hp(5.5),
        ),
      ),
    );
  }
}
