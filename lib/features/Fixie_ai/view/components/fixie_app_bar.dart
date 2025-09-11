// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/viewmodel/bloc/chat_bloc.dart';

class FixieAppBar extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> pulseAnimation;
  final Responsive responsive;
  final VoidCallback onHelpPressed;
  final VoidCallback onRefreshPressed;

  const FixieAppBar({
    super.key,
    required this.fadeAnimation,
    required this.pulseAnimation,
    required this.responsive,
    required this.onHelpPressed,
    required this.onRefreshPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(5),
          vertical: responsive.hp(2),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade100.withValues(alpha: 0.3),
              Colors.deepPurple.shade50.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(responsive.wp(6)),
          ),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            _buildLogoSection(),
            SizedBox(width: responsive.wp(4)),
            Expanded(child: _buildTitleSection()),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.all(responsive.wp(3)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(responsive.wp(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: responsive.wp(3),
                  spreadRadius: responsive.wp(0.5),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: responsive.wp(6),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade800,
            ],
          ).createShader(bounds),
          child: Text(
            'Fixie AI',
            style: TextStyle(
              fontSize: responsive.sp(22),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          'Your AI Pitch Assistant',
          style: TextStyle(
            fontSize: responsive.sp(14),
            color: Colors.deepPurple.shade600.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.help_outline,
          onPressed: onHelpPressed,
        ),
        SizedBox(width: responsive.wp(2)),
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final isEnabled = state is ChatLoaded && state.messages.length > 1;
            return _buildActionButton(
              icon: Icons.refresh,
              onPressed: isEnabled ? onRefreshPressed : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(responsive.wp(2)),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(responsive.wp(3)),
          border: Border.all(
            color: Colors.deepPurple.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.deepPurple.shade600,
          size: responsive.wp(5),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
