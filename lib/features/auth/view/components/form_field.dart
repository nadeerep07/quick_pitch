import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final bool isVisible;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: (val) {
        if (val == null || val.isEmpty) return '$hint is required';
        if (hint == 'Email' && !val.contains('@')) return 'Enter a valid email';
        if (isPassword && val.length < 6) return 'Minimum 6 characters';
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
