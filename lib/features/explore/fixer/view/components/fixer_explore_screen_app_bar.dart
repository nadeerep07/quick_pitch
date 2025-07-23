import 'package:flutter/material.dart';

class FixerExploreScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FixerExploreScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Explore Tasks'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
