import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/repository/fixer_works_repository.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_empty_view.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_error_view.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_item.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/widgets/portfolio_loading_view.dart';

class FixerDetailPortfolioSection extends StatelessWidget {
  const FixerDetailPortfolioSection({
    super.key,
    required this.res,
    required this.theme,
    required this.fixerId,
  });

  final Responsive res;
  final ThemeData theme;
  final String fixerId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Works",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(1)),
        StreamBuilder<List<FixerWork>>(
          stream: FixerWorksRepository().getFixerWorks(fixerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return PortfolioLoadingView(res: res);
            }

            if (snapshot.hasError) {
              return PortfolioErrorView(
                res: res,
                theme: theme,
                error: snapshot.error.toString(),
              );
            }

            final works = snapshot.data ?? [];
            if (works.isEmpty) {
              return PortfolioEmptyView(res: res, theme: theme);
            }

            return Column(
              children: works.map(
                (work) => PortfolioItem(work: work, res: res, theme: theme),
              ).toList(),
            );
          },
        ),
      ],
    );
  }
}

