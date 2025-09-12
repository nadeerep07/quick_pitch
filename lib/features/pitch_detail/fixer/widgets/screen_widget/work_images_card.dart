import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/section_card.dart';

class WorkImagesCard extends StatelessWidget {
  final HireRequest request;

  const WorkImagesCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return SectionCard(
      title: 'Work Images',
      icon: Icons.image,
      children: [
        SizedBox(
          height: res.wp(40),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: request.workImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: res.wp(3)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    request.workImages[index],
                    width: res.wp(32),
                    height: res.wp(40),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: res.wp(32),
                        height: res.wp(40),
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: theme.colorScheme.outline,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
