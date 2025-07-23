import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class CardLocation extends StatelessWidget {
  const CardLocation({
    super.key,
    required this.location,
    required this.res,
  });

  final String location;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: res.sp(13), color: Colors.grey),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: res.sp(11),
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
