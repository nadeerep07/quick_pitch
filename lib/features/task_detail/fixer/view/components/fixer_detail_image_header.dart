import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerDetailImageHeader extends StatelessWidget {
  const FixerDetailImageHeader({
    super.key,
    required this.imageUrl,
    required this.res,
    required this.priorityLabel,
  });

  final String imageUrl;
  final Responsive res;
  final String priorityLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: res.hp(25),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
        ),
        Positioned(
          top: res.hp(1.5),
          right: res.wp(3),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
            child:  Text(priorityLabel, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}
