import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class LoadingView extends StatelessWidget {
  final Responsive res;

  const LoadingView({required this.res});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: res.hp(2)),
          Text(
            'Loading available works...',
            style: TextStyle(fontSize: res.sp(16), color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
