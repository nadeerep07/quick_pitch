import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/cubit/poster_explore_cubit.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterExploreErrorView extends StatelessWidget {
  final String message;

  const PosterExploreErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: res.hp(2)),
            Text('Something went wrong', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.red[700])),
            SizedBox(height: res.hp(1)),
            Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
            SizedBox(height: res.hp(4)),
            ElevatedButton.icon(
              onPressed: () => context.read<PosterExploreCubit>().load(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: res.wp(6), vertical: res.hp(1.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
