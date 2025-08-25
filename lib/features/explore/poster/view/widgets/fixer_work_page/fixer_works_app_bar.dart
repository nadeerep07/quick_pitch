// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerWorksAppBar extends StatelessWidget {
  final UserProfileModel fixer;
  final FixerWorksState state;
  final VoidCallback onClose;

  const FixerWorksAppBar({
    required this.fixer,
    required this.state,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${fixer.name}\'s Works',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          if (state is FixerWorksLoaded)
            Text(
              '${(state as FixerWorksLoaded).works.length} portfolio item${(state as FixerWorksLoaded).works.length != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black87),
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}
