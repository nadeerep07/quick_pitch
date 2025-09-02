import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// ---------------------------
/// 🔹 LOADING STATE
/// ---------------------------
class PortfolioLoadingView extends StatelessWidget {
  final Responsive res;
  const PortfolioLoadingView({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.hp(4)),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

