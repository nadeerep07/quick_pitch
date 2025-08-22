import 'package:flutter/material.dart';

class WorkDetailAnimatedBackground extends StatefulWidget {
  final Widget child;
  final ThemeData theme;

  const WorkDetailAnimatedBackground({
    super.key,
    required this.child,
    required this.theme,
  });

  @override
  State<WorkDetailAnimatedBackground> createState() => 
      _WorkDetailAnimatedBackgroundState();
}

class _WorkDetailAnimatedBackgroundState extends State<WorkDetailAnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(
                    0.5 + 0.3 * (0.5 - _animation.value),
                    0.5 + 0.2 * (0.5 - _animation.value),
                  ),
                  radius: 1.5,
                  colors: [
                    widget.theme.colorScheme.primary.withOpacity(0.03),
                    widget.theme.colorScheme.secondary.withOpacity(0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}