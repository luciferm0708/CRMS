import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? fillColors;
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
          borderSide: BorderSide(color: fillColors ?? Colors.deepPurpleAccent, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fillColors ?? Colors.deepPurpleAccent, width: 2.5),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: fillColors,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.blueGrey),
        suffixIcon: showToggle == true
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: onToggle,
        )
            : suffixIcon,
      ),
      onTap: readOnly == true ? () {} : null,
      validator: validator,
    );
  }
}
