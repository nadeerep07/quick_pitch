import 'package:flutter/material.dart';

/// ----------------------------
/// Section: Avatar
/// ----------------------------
class PaymentAvatar extends StatelessWidget {
  final String? posterImage;
  const PaymentAvatar({this.posterImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.blue.shade100,
      backgroundImage: posterImage != null ? NetworkImage(posterImage!) : null,
      child: posterImage == null
          ? Icon(Icons.person, color: Colors.blue.shade600)
          : null,
    );
  }
}

