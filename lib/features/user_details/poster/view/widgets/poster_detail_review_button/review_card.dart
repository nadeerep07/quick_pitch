import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final ReviewModel review;
  final String reviewerName;
  final String? reviewerImage;

  const ReviewCard({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.review,
    required this.reviewerName,
    required this.reviewerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(70),
      margin: EdgeInsets.only(right: res.wp(3)),
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: res.wp(4),
                backgroundImage: reviewerImage != null && reviewerImage!.isNotEmpty
                    ? NetworkImage(reviewerImage!)
                    : const AssetImage('assets/images/avatar_photo_placeholder.jpg')
                        as ImageProvider,
              ),
              SizedBox(width: res.wp(2)),
              Expanded(
                child: Text(
                  reviewerName,
                  style: TextStyle(
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < (review.rating)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: res.sp(12),
                        color: Colors.amber,
                      );
                    }),
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    '${DateTime.now().difference(review.createdAt).inDays}d ago',
                    style: TextStyle(fontSize: res.sp(10), color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
          Expanded(
            child: Text(
              review.comment ,
              style: TextStyle(fontSize: res.sp(12), color: Colors.grey[700]),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
