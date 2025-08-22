import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';

class CardContent extends StatelessWidget {
  final ThemeData theme;
  final FixerWork work;

  const CardContent({super.key, required this.theme, required this.work});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Padding(
      padding: EdgeInsets.all(res.wp(4)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            work.title,
            style: theme.textTheme.titleMedium?.copyWith(
             fontSize: res.sp(16),
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: res.hp(0.8)),
          Text(
            work.description,
            
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: res.hp(0.8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(2),
                  vertical: res.hp(0.5),
                ),

                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:Text(currency.format(work.amount),
                ),
              ),
              Text(
                work.time,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
