import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeTaskCard extends StatelessWidget {
  const PosterHomeTaskCard({
    super.key,
    required this.res,
    required this.title,
    this.fixerName,
    required this.status,
    required this.imageUrl,
  });

  final Responsive res;
  final String title;
  final String status;
  final String imageUrl;
  final String? fixerName;

  @override
  Widget build(BuildContext context) {
  Color statusColor;
  switch (status) {
    case 'Completed':
      statusColor = Colors.green;
      break;
    case 'In Progress':
      statusColor = Colors.orange;
      break;
    case 'Pending':
    default:
      statusColor = Colors.red;
  }

  return Container(
    width: res.wp(60),
    margin: EdgeInsets.only(right: res.wp(4)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.all(res.hp(1.5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/task_placeholder.webp',
            image: imageUrl,
            height: res.hp(10),
            width: double.infinity,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/task_placeholder.png',
                height: res.hp(10),
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        SizedBox(height: res.hp(1)),
        Text(
          title,
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (fixerName != null) ...[
          SizedBox(height: res.hp(0.5)),
          Text(
            'Assigned to: $fixerName',
            style: TextStyle(
              fontSize: res.sp(12),
              color: Colors.grey[600],
            ),
          ),
        ],
        SizedBox(height: res.hp(0.5)),
        Chip(
          label: Text(
            status,
            style: TextStyle(color: Colors.white, fontSize: res.sp(11)),
          ),
          backgroundColor: statusColor,
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ],
    ),
  );
}
}
