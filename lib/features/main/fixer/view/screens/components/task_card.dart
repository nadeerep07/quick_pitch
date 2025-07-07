import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String location;
  final String budget;
  final List<String>? imageUrls;
  final VoidCallback onTap;

  const TaskCard({
    required this.title,
    required this.location,
    required this.budget,
    required this.onTap,
    this.imageUrls,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: res.hp(2)),
        padding: EdgeInsets.all(res.hp(1.5)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ///  Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrls != null && imageUrls!.isNotEmpty
                  ? Image.network(
                      imageUrls!.first,
                      width: res.wp(25),
                      height: res.wp(25),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: res.wp(25),
                      height: res.wp(25),
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported,
                          size: res.sp(20), color: Colors.grey),
                    ),
            ),

            SizedBox(width: res.wp(4)),

            /// Task Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: res.sp(15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: res.hp(0.7)),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: res.sp(14), color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: res.sp(13),
                              color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(0.8)),
                  Text(
                    '₹$budget',
                    style: TextStyle(
                      fontSize: res.sp(14),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded,
                size: res.sp(14), color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
