import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/chip_tag.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/work_image.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class WorkCard extends StatelessWidget {
  final FixerWork work;
  final bool isSelected;
  final Responsive res;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const WorkCard({
    required this.work,
    required this.isSelected,
    required this.res,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(res.wp(4)),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              WorkImage(work: work, res: res, colorScheme: colorScheme),
              SizedBox(width: res.wp(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (work.description.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: res.hp(0.5)),
                        child: Text(
                          work.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    SizedBox(height: res.hp(1)),
                    Row(
                      children: [
                        ChipTag(
                          text: '\$${work.amount.toStringAsFixed(0)}',
                          res: res,
                          bg: colorScheme.primaryContainer,
                          fg: colorScheme.onPrimaryContainer,
                          theme: theme,
                        ),
                        SizedBox(width: res.wp(2)),
                        if (work.time.isNotEmpty)
                          ChipTag(
                            text: work.time,
                            res: res,
                            bg: colorScheme.secondaryContainer,
                            fg: colorScheme.onSecondaryContainer,
                            theme: theme,
                          ),
                        Spacer(),
                        if (isSelected)
                          CircleAvatar(
                            radius: res.sp(12),
                            backgroundColor: colorScheme.primary,
                            child: Icon(
                              Icons.check,
                              color: colorScheme.onPrimary,
                              size: res.sp(16),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
