import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreShimmer extends StatefulWidget {
  const PosterExploreShimmer({super.key});

  @override
  State<PosterExploreShimmer> createState() => _PosterExploreShimmerState();
}

class _PosterExploreShimmerState extends State<PosterExploreShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nearby toggle shimmer
              _buildShimmerContainer(
                width: double.infinity,
                height: res.hp(8),
                radius: 16,
              ),

              SizedBox(height: res.hp(3)),

              // Section title shimmer
              _buildShimmerContainer(
                width: res.wp(40),
                height: res.hp(2.5),
                radius: 8,
              ),

              SizedBox(height: res.hp(2)),

              // Cards shimmer
              ...List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: res.hp(2)),
                  child: _buildShimmerContainer(
                    width: double.infinity,
                    height: res.hp(12),
                    radius: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops:
              [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}