import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/review/cubit/review_cubit.dart';

class ReviewsErrorView extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final String message;

  const ReviewsErrorView({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: res.sp(48), color: colorScheme.error),
          SizedBox(height: res.hp(2)),
          Text(message, style: TextStyle(fontSize: res.sp(16), color: colorScheme.onSurface)),
          SizedBox(height: res.hp(2)),
          ElevatedButton(
            onPressed: () => context.read<ReviewCubit>().fetchReviews(limit: 10),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
