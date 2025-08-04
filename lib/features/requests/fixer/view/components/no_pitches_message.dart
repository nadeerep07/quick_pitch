import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class NoPitchesMessage extends StatelessWidget {
  final String filter;
  final Responsive res;
  final ThemeData theme;

  const NoPitchesMessage({
    super.key,
    required this.filter,
    required this.res,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: res.hp(20)),
        Center(
          child: Text(
            "No ${filter.toLowerCase()} pitches yet",
            style: TextStyle(
              fontSize: res.sp(14),
              color: theme.hintColor,
            ),
          ),
        ),
      ],
    );
  }
}
