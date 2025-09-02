// Updated FixerWorksPage

import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_fixer_work_page/empty_state.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_fixer_work_page/error_state.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_fixer_work_page/loading_state.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/works_content.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/works_content_with_loading_more.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerWorksContent extends StatelessWidget {
  final FixerWorksState state;
  final UserProfileModel fixer;
  final Animation<double> fadeAnimation;
  final VoidCallback onRefresh;
  final VoidCallback onRetry;

  const FixerWorksContent({super.key, 
    required this.state,
    required this.fixer,
    required this.fadeAnimation,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.runtimeType) {
      case FixerWorksLoading:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: LoadingState(),
        );
      
      case FixerWorksError:
        final errorState = state as FixerWorksError;
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ErrorState(
            errorMessage: errorState.message,
            onRetry: onRetry,
            fadeAnimation: fadeAnimation,
          ),
        );
      
      case FixerWorksLoaded:
        final loadedState = state as FixerWorksLoaded;
        if (loadedState.works.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmptyState(
              fixer: fixer,
              fadeAnimation: fadeAnimation,
            ),
          );
        }
        return WorksContent(
          state: loadedState,
          onRefresh: onRefresh,
        );
      
      case FixerWorksLoadingMore:
        final loadingMoreState = state as FixerWorksLoadingMore;
        return WorksContentWithLoadingMore(
          works: loadingMoreState.existingWorks,
          onRefresh: onRefresh,
        );
      
      case FixerWorksRefreshing:
        final refreshingState = state as FixerWorksRefreshing;
        return WorksContent(
          state: FixerWorksLoaded(
            works: refreshingState.existingWorks,
            hasMoreData: false,
            totalCount: refreshingState.existingWorks.length,
          ),
          onRefresh: onRefresh,
          isRefreshing: true,
        );
      
      default:
        return const SizedBox.shrink();
    }
  }
}
