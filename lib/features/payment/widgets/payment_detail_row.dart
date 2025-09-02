import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

/// ---------------------- DETAIL ROW ----------------------
class PaymentDetailRow extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isMultiline;

  const PaymentDetailRow({
    super.key,
    required this.res,
    required this.theme,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: res.wp(4.5)),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: res.hp(0.5)),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
