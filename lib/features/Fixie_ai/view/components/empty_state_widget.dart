// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class EmptyStateWidget extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> pulseAnimation;
  final Responsive responsive;

  const EmptyStateWidget({
    super.key,
    required this.fadeAnimation,
    required this.pulseAnimation,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(),
            SizedBox(height: responsive.hp(4)),
            _buildTitle(),
            SizedBox(height: responsive.hp(2)),
            _buildSubtitle(),
            SizedBox(height: responsive.hp(4)),
            _buildHintContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: pulseAnimation.value * 0.1 + 0.9,
          child: Container(
            width: responsive.wp(30),
            height: responsive.wp(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.deepPurple.shade600,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: responsive.wp(8),
                  spreadRadius: responsive.wp(2.5),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              size: responsive.wp(15),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.deepPurple.shade600,
          Colors.deepPurple.shade800,
        ],
      ).createShader(bounds),
      child: Text(
        'Ready to craft your perfect pitch?',
        style: TextStyle(
          fontSize: responsive.sp(responsive.isMobile ? 24 : 28),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      child: Text(
        'I\'ll help you create compelling presentations\nthat captivate investors and audiences',
        style: TextStyle(
          fontSize: responsive.sp(16),
          color: Colors.deepPurple.shade600.withValues(alpha: 0.7),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHintContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(6),
        vertical: responsive.hp(1.5),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withValues(alpha: 0.1),
            Colors.deepPurple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.wp(5)),
        border: Border.all(
          color: Colors.deepPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        'Try the quick actions above or start typing',
        style: TextStyle(
          color: Colors.deepPurple.shade600.withValues(alpha: 0.8),
          fontSize: responsive.sp(14),
        ),
      ),
    );
  }
}
