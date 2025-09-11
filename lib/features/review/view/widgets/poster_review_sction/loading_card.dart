import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class LoadingCard extends StatelessWidget {
  final Responsive res;
  const LoadingCard({required this.res});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
