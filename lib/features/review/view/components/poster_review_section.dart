import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/review/model/review_model.dart';
import 'package:quick_pitch_app/features/review/service/review_service.dart';
import 'package:quick_pitch_app/features/review/view/widgets/review_rating_widget.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

class PosterReviewSection extends StatefulWidget {
  final PitchModel pitch;
  final String fixerId;
  final String fixerName;
  final String? fixerImageUrl;

  const PosterReviewSection({
    Key? key,
    required this.pitch,
    required this.fixerId,
    required this.fixerName,
    this.fixerImageUrl,
  }) : super(key: key);

  @override
  State<PosterReviewSection> createState() => _PosterReviewSectionState();
}

class _PosterReviewSectionState extends State<PosterReviewSection> {
  final ReviewService _reviewService = ReviewService();
  ReviewModel? _existingReview;
  bool _canReview = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkReviewStatus();
  }

  Future<void> _checkReviewStatus() async {
    try {
      final currentUserId = 'current_user_id'; // Get from your auth service
      
      final canReview = await _reviewService.canUserReview(currentUserId, widget.pitch.id);
      final existingReview = await _reviewService.getReviewBetweenUsers(currentUserId, widget.pitch.id);
      
      if (mounted) {
        setState(() {
          _canReview = canReview;
          _existingReview = existingReview;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => ReviewRatingWidget(
        revieweeId: widget.fixerId,
        revieweeName: widget.fixerName,
        pitchId: widget.pitch.id,
        taskId: widget.pitch.taskId ?? '',
        reviewerType: 'poster',
        existingReview: _existingReview,
        onReviewSubmitted: () {
          _checkReviewStatus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rate,
                  color: Colors.amber,
                  size: res.wp(6),
                ),
                SizedBox(width: res.wp(2)),
                Text(
                  'Rate Fixer',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1.5)),

            if (_existingReview != null) ...[
              // Show existing review
              Container(
                padding: EdgeInsets.all(res.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: res.wp(4)),
                        SizedBox(width: res.wp(2)),
                        Text(
                          'You have reviewed this fixer',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: res.hp(1)),
                    
                    StarRatingDisplay(
                      rating: _existingReview!.rating,
                      starSize: res.wp(4),
                      showText: false,
                    ),
                    SizedBox(height: res.hp(0.5)),
                    
                    Text(
                      _existingReview!.comment,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: res.hp(1.5)),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showReviewDialog,
                      icon: Icon(Icons.edit, size: res.wp(4)),
                      label: const Text('Edit Review'),
                    ),
                  ),
                ],
              ),
            ] else if (_canReview && widget.pitch.status == 'completed') ...[
              // Show review prompt
              Container(
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
                          backgroundImage: widget.fixerImageUrl != null
                              ? NetworkImage(widget.fixerImageUrl!)
                              : null,
                          child: widget.fixerImageUrl == null
                              ? Text(
                                  widget.fixerName.isNotEmpty 
                                      ? widget.fixerName[0].toUpperCase() 
                                      : '?',
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
                                'How was ${widget.fixerName}?',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Rate your experience with this fixer',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
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
                        onPressed: _showReviewDialog,
                        icon: Icon(Icons.star_rate, size: res.wp(4)),
                        label: const Text('Write Review'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: res.hp(1.2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (!_canReview) ...[
              // Already reviewed or can't review
              Container(
                padding: EdgeInsets.all(res.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.grey[600], size: res.wp(5)),
                    SizedBox(width: res.wp(3)),
                    Expanded(
                      child: Text(
                        'Reviews can only be submitted after task completion',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Task not completed yet
              Container(
                padding: EdgeInsets.all(res.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pending, color: Colors.orange[600], size: res.wp(5)),
                    SizedBox(width: res.wp(3)),
                    Expanded(
                      child: Text(
                        'You can review this fixer once the task is completed',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}