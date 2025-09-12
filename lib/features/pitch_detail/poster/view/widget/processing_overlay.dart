import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class ProcessingOverlay extends StatelessWidget {
  final Responsive res;
  final ThemeData theme;

  const ProcessingOverlay({super.key, required this.res, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(res.wp(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: res.hp(2)),
                Text(
                  'Processing payment...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
