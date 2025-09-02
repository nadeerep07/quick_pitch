import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_content.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_image_carousel.dart';

/// ---------------------------
/// 🔹 PORTFOLIO ITEM
/// ---------------------------
class PortfolioItem extends StatelessWidget {
  final FixerWork work;
  final Responsive res;
  final ThemeData theme;

  const PortfolioItem({
    super.key,
    required this.work,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (work.images.isNotEmpty)
            PortfolioImageCarousel(images: work.images, res: res, theme: theme),
          PortfolioContent(work: work, res: res, theme: theme),
        ],
      ),
    );
  }
}

