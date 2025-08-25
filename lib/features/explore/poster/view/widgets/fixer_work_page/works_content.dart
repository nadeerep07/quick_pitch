// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/stats_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/work_card.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';

class WorksContent extends StatelessWidget {
  final FixerWorksLoaded state;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  const WorksContent({
    required this.state,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StatsCard(worksCount: state.totalCount),
            ...List.generate(state.works.length, (index) {
              return WorkCard(work: state.works[index], index: index);
            }),
            if (isRefreshing)
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[600]!,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Refreshing works...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
