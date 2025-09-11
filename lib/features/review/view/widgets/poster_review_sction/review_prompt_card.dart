import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ReviewPromptCard extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  final String fixerName;
  final String? fixerImageUrl;
  final VoidCallback onPressed;

  const ReviewPromptCard({
    required this.res,
    required this.theme,
    required this.fixerName,
    required this.fixerImageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: res.wp(4),
                backgroundImage: fixerImageUrl != null ? NetworkImage(fixerImageUrl!) : null,
                child: fixerImageUrl == null
                    ? Text(
                        fixerName.isNotEmpty ? fixerName[0].toUpperCase() : '?',
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
                      'How was $fixerName?',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Rate your experience with this fixer',
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
              onPressed: onPressed,
              icon: Icon(Icons.star_rate, size: res.wp(4)),
              label: const Text('Write Review'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: res.hp(1.2))),
            ),
          ),
        ],
      ),
    );
  }
}
