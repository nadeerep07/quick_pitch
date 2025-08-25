// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/stats_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/work_card.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class WorksContentWithLoadingMore extends StatelessWidget {
  final List<FixerWork> works;
  final VoidCallback onRefresh;

  const WorksContentWithLoadingMore({
    required this.works,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StatsCard(worksCount: works.length),
            ...List.generate(works.length, (index) {
              return WorkCard(work: works[index], index: index);
            }),
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
                    'Loading more works...',
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
