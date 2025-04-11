import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? fillColors;
  final Color? borderColor;  // New border color property
  final bool? showToggle;
  final VoidCallback? onToggle;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.readOnly = false,
    this.suffixIcon,
    this.fillColors,
    this.borderColor,  // Added parameter
    this.showToggle,
    this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,  // Use borderColor or default
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.blueGrey,  // Use borderColor or default
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: fillColors,
        filled: fillColors != null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        suffixIcon: showToggle == true
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[700],
          ),
          onPressed: onToggle,
        )
            : suffixIcon,
      ),
      onTap: readOnly == true ? () {} : null,
      validator: validator,
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 16,
      ),
    );
  }
}