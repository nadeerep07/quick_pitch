import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class CustomReasonField extends StatelessWidget {
  final TextEditingController controller;
  final Responsive res;

  const CustomReasonField({required this.controller, required this.res});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Please specify the reason...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.all(res.wp(3)),
      ),
    );
  }
}
