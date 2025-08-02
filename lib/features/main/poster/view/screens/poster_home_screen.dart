import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_list.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_header.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_actions.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_shimmer.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_sumary_card.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_list.dart';
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
    //    print(' Initializing PosterHomeScreen - calling streamPosterHomeData');
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
            //  print(' Refresh triggered');
              context.read<PosterHomeCubit>().streamPosterHomeData();
            },
            child: BlocBuilder<PosterHomeCubit, PosterHomeState>(
              builder: (context, state) {
               // print('PosterHomeState changed: $state');
                
                if (state is PosterHomeLoading) {
               //   print(' Showing shimmer loading...');
                  return const PosterHomeShimmer();
                }
                
                if (state is PosterHomeLoaded) {
                 // print('Showing loaded content with ${state.tasks.length} tasks and ${state.fixers.length} fixers');
                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: res.wp(5),
                      vertical: res.hp(2),
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      PosterHomeHeader(res: res),
                      const SizedBox(height: 20),
                      const PosterHomeSummaryCard(),
                      const SizedBox(height: 20),
                      const PosterHomeTaskList(),
                      const SizedBox(height: 20),
                      const PosterHomeFixerList(),
                      const SizedBox(height: 20),
                      const PosterHomeQuickActions(),
                    ],
                  );
                }
                
                if (state is PosterHomeError) {
                 //  print(' Error state: ${state.message}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          "Error: ${state.message}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PosterHomeCubit>().streamPosterHomeData();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
              //   print(' Unknown state: $state');
                return const Center(child: Text("Something went wrong!"));
              },
            ),
          ),
        ),
      ),
    );
  }
}