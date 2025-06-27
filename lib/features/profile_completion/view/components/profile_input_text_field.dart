import 'package:flutter/material.dart';

class ProfileInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final bool isMultiline;
   final bool isReadOnly;
  final IconData? icon;
  final VoidCallback? onLocationTap;
  final TextInputType? keyboardType;
final String? dynamicHelperText;


  const ProfileInputField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.isMultiline = false,
     this.isReadOnly = false,
    this.onLocationTap,
    this.keyboardType,
    this.icon,
    this.dynamicHelperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            children: [
              if (isRequired)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: isReadOnly ,
          controller: controller,
          maxLines: isMultiline ? null : 1,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return '$label is required';
            }
            // if (label == "About You" && (value?.split(" ").length ?? 0) < 10) {
            //   return 'Minimum 30 characters required';
            // }
            return null;
          },
          onTap: isReadOnly ? onLocationTap : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: icon != null
                ? IconButton(
                    icon: Icon(icon),
                    onPressed: onLocationTap,
                  )
                : null,
            helperText: dynamicHelperText ?? (isMultiline ? "You can write a brief about yourself" : ""),
          ),
        ),
      ],
    );
  }
}
