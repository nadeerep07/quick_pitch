import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReviewsHeader extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;

  const ReviewsHeader({
    super.key,
    required this.res,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(2)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          Text(
            'All Reviews',
            style: TextStyle(fontSize: res.sp(18), fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: colorScheme.onSurface, size: res.sp(20)),
          ),
        ],
      ),
    );
  }
}
