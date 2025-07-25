import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class BuildSectionTitle extends StatefulWidget {
  const BuildSectionTitle({
    super.key,
    required this.res,
    required this.title,
  });

  final Responsive res;
  final String title;

  @override
  State<BuildSectionTitle> createState() => _BuildSectionTitleState();
}

class _BuildSectionTitleState extends State<BuildSectionTitle> {
  Set<String> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.res.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),


      ],
    );
  }
}
