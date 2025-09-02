import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class AmountField extends StatelessWidget {
  final Responsive res;
  final TextEditingController controller;
  final ThemeData theme;
  const AmountField({super.key, required this.res, required this.controller, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Amount', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: res.hp(1)),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          decoration: InputDecoration(
            hintText: 'Enter amount',
            prefixText: '\$',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter an amount';
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) return 'Please enter a valid amount';
            return null;
          },
        ),
      ],
    );
  }
}
