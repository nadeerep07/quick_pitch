import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Responsive res;
  final ThemeData theme;
  final bool isMultiline;
  final Color? valueColor;

  const PaymentDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.res,
    required this.theme,
    this.isMultiline = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: res.wp(0.5)),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: res.wp(25),
            child: Text(
              label,
              style: TextStyle(
                fontSize: res.sp(13),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: res.wp(2)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: res.sp(13),
                color: valueColor ?? theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
