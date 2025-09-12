import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReviewPromptCard extends StatelessWidget {
  final String posterName;
  final String? posterImageUrl;
  final VoidCallback onWriteReview;

  const ReviewPromptCard({
    required this.posterName,
    this.posterImageUrl,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Container(
          padding: EdgeInsets.all(res.wp(3)),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.primaryColor.withValues(alpha:0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: res.wp(4),
                    backgroundImage: posterImageUrl != null ? NetworkImage(posterImageUrl!) : null,
                    child: posterImageUrl == null
                        ? Text(
                            posterName.isNotEmpty ? posterName[0].toUpperCase() : '?',
                            style: TextStyle(fontSize: res.wp(3)),
                          )
                        : null,
                  ),
                  SizedBox(width: res.wp(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How was $posterName?',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Rate your experience with this poster',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: res.hp(1.5)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onWriteReview,
                  icon: Icon(Icons.rate_review, size: res.wp(4)),
                  label: const Text('Write Review'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: res.hp(1.2))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
