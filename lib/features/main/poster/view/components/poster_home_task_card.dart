import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeTaskCard extends StatelessWidget {
  final Responsive res;
  final String title;
  final String status;
  final String imageUrl;
  final String fixerName;

  const PosterHomeTaskCard({
    super.key,
    required this.res,
    required this.title,
    required this.status,
    required this.imageUrl,
    required this.fixerName,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.redAccent;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'in progress':
        return Icons.schedule;
      case 'pending':
      default:
        return Icons.timelapse;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(60),
      margin: EdgeInsets.only(right: res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Image with overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/task_placeholder.webp',
                  image: imageUrl,
                  height: res.hp(14),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/default_task.jpg',
                    height: res.hp(14),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //  Status Tag
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(_statusIcon(status), color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //  Task Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: res.sp(15),
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/default_user.png'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fixerName,
                      style: TextStyle(
                        fontSize: res.sp(13),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
