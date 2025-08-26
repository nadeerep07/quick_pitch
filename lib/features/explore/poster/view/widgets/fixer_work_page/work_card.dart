// Updated FixerWorksPage

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/description_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/price_card.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/project_type_chip.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/work_image_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/work_metadata.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class WorkCard extends StatelessWidget {
  final FixerWork work;
  final int index;

  const WorkCard({super.key, required this.work, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (work.images.isNotEmpty)
                        WorkImageSection(images: work.images),
                      
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        work.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A1A),
                                          letterSpacing: -0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ProjectTypeChip(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                PriceCard(amount: work.amount),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            DescriptionCard(description: work.description),
                            
                            const SizedBox(height: 20),
                            
                            WorkMetadata(work: work),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
