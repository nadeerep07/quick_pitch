import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class ReviewRatingWidget extends StatefulWidget {
  final String revieweeId;
  final String revieweeName;
  final String pitchId;
  final String taskId;
  final String reviewerType; // 'poster' or 'fixer'
  final VoidCallback? onReviewSubmitted;
  final ReviewModel? existingReview;

  const ReviewRatingWidget({
    Key? key,
    required this.revieweeId,
    required this.revieweeName,
    required this.pitchId,
    required this.taskId,
    required this.reviewerType,
    this.onReviewSubmitted,
    this.existingReview,
  }) : super(key: key);

  @override
  State<ReviewRatingWidget> createState() => _ReviewRatingWidgetState();
}

class _ReviewRatingWidgetState extends State<ReviewRatingWidget> {
  final TextEditingController _commentController = TextEditingController();
  final ReviewService _reviewService = ReviewService(); // Add this
  double _rating = 0.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating;
      _commentController.text = widget.existingReview!.comment;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildStarRating(Responsive res) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        return GestureDetector(
          onTap: () => setState(() => _rating = starValue),
          child: Icon(
            _rating >= starValue ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: res.wp(8),
          ),
        );
      }),
    );
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get current user ID from Firebase Auth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final review = ReviewModel(
        id: widget.existingReview?.id ?? '', // Will be set by service if empty
        reviewerId: currentUser.uid, // Use actual user ID
        revieweeId: widget.revieweeId,
        pitchId: widget.pitchId,
        taskId: widget.taskId,
        rating: _rating,
        comment: _commentController.text.trim(),
        reviewerType: widget.reviewerType,
        createdAt: widget.existingReview?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Submit review using your service
      if (widget.existingReview != null) {
        // Update existing review
        await _reviewService.updateReview(review);
      } else {
        // Submit new review
        await _reviewService.submitReview(review);
      }

      if (mounted) {
        Navigator.of(context).pop();
        widget.onReviewSubmitted?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingReview != null 
                ? 'Review updated successfully!' 
                : 'Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error submitting review: $e'); // Add logging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rate & Review',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: res.hp(1)),
            
            Text(
              'How was your experience with ${widget.revieweeName}?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(3)),

            // Star Rating
            _buildStarRating(res),
            SizedBox(height: res.hp(2)),

            Text(
              _getRatingText(_rating),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: _getRatingColor(_rating),
              ),
            ),
            SizedBox(height: res.hp(3)),

            // Comment TextField
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
            ),
            SizedBox(height: res.hp(3)),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(widget.existingReview != null ? 'Update' : 'Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating == 0) return Colors.grey;
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.blue;
    return Colors.green;
  }
}

// Star Rating Display Widget
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final double starSize;
  final bool showText;

  const StarRatingDisplay({
    Key? key,
    required this.rating,
    this.totalReviews = 0,
    this.starSize = 16,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final filled = rating > index;
          final halfFilled = rating > index && rating < index + 1;
          
          return Icon(
            halfFilled ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
            color: Colors.amber,
            size: starSize,
          );
        }),
        
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            '${rating.toStringAsFixed(1)}${totalReviews > 0 ? ' ($totalReviews)' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// Review Card Widget
class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String reviewerName;
  final String? reviewerImageUrl;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.reviewerName,
    this.reviewerImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: res.hp(1)),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: res.wp(5),
                  backgroundImage: reviewerImageUrl != null
                      ? NetworkImage(reviewerImageUrl!)
                      : null,
                  child: reviewerImageUrl == null
                      ? Text(reviewerName.isNotEmpty ? reviewerName[0].toUpperCase() : '?')
                      : null,
                ),
                SizedBox(width: res.wp(3)),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      StarRatingDisplay(
                        rating: review.rating,
                        starSize: res.wp(4),
                        showText: false,
                      ),
                    ],
                  ),
                ),
                
                Text(
                  _formatDate(review.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),
            
            Text(
              review.comment,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}