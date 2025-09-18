import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/review_empty.dart' show ReviewsEmptyView;
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/review_error)view.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/review_header.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/review_list.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/review/review_loading.dart';
import 'package:quick_pitch_app/features/user_details/fixer/viewmodel/review/cubit/review_cubit.dart';

class AllReviewsBottomSheet extends StatelessWidget {
  final Responsive res;
  final ColorScheme colorScheme;
  final UserProfileModel fixer;
  final UserProfileService userProfileService;
  final Map<String, UserProfileModel> reviewerProfiles;

  const AllReviewsBottomSheet({
    super.key,
    required this.res,
    required this.colorScheme,
    required this.fixer,
    required this.userProfileService,
    required this.reviewerProfiles,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
          context.read<ReviewCubit>().state is ReviewLoaded) {
        context.read<ReviewCubit>().loadMoreReviews();
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          ReviewsHeader(res: res, colorScheme: colorScheme),
          Expanded(
            child: BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoading) return ReviewsLoading(colorScheme: colorScheme);
                if (state is ReviewError) return ReviewsErrorView(res: res, colorScheme: colorScheme, message: state.message);
                if (state is ReviewLoaded || state is ReviewLoadingMore) {
                  final reviews = state is ReviewLoaded ? state.reviews : (state as ReviewLoadingMore).reviews;
                  if (reviews.isEmpty) return ReviewsEmptyView(res: res, colorScheme: colorScheme);

                  return ReviewsList(
                    res: res,
                    colorScheme: colorScheme,
                    reviews: reviews,
                    reviewerProfiles: reviewerProfiles,
                    userProfileService: userProfileService,
                    scrollController: scrollController,
                    isLoadingMore: state is ReviewLoadingMore,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
