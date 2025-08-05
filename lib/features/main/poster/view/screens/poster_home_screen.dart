import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_errorstate.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_section.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_actions.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_shimmer.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_section.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_user_header.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_homedash_board_state.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';


class PosterHomeScreen extends StatefulWidget {
  const PosterHomeScreen({super.key});

  @override
  State<PosterHomeScreen> createState() => _PosterHomeScreenState();
}

class _PosterHomeScreenState extends State<PosterHomeScreen> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        context.read<PosterHomeCubit>().streamPosterHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: CustomPaint(
        painter: MainBackgroundPainter(),
        child: SafeArea(
          bottom: true,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<PosterHomeCubit>().streamPosterHomeData();
            },
            child: BlocBuilder<PosterHomeCubit, PosterHomeState>(
              builder: (context, state) {
                if (state is PosterHomeLoading) {
                  return const PosterHomeShimmer();
                }

                if (state is PosterHomeLoaded) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Professional App Bar
                      SliverToBoxAdapter(
                        child: PosterHomeUserHeader(context: context, res: res, state: state),
                      ),

                      // Dashboard Stats
                      SliverToBoxAdapter(
                        child: PosterHomedashBoardState(res: res, state: state),
                      ),

                      // Quick Actions
                      SliverToBoxAdapter(
                        child: PosterHomeQuickActions(res: res, context: context),
                      ),

                      // Recent Tasks Section
                      SliverToBoxAdapter(
                        child: PosterHomeTaskSection(res: res, state: state, context: context),
                      ),

                      // Recommended Fixers
                      SliverToBoxAdapter(
                        child: PosterHomeFixerSection(res: res, state: state, context: context),
                      ),

                      // Bottom padding
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                    ],
                  );
                }

                if (state is PosterHomeError) {
                  return PosterHomeErrorstate(context: context, state: state);
                }

                return const Center(child: Text("Something went wrong!"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
