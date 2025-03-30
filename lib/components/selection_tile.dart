import 'package:flutter/material.dart';

class MySelectionTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final void Function(String?)? onChanged;
  final double height;
  final double width;
  final Color backgroundColor;  // Custom background color
  final Color borderColor;  // Custom border color
  final Color textColor;

  const MySelectionTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.height = 60.0,
    this.width = double.infinity,
    this.backgroundColor = Colors.white,  // Default background color
    this.borderColor = Colors.green,      // Default border color
    this.textColor = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor,  // Set the background color
          border: Border.all(
            color: borderColor,  // Set the custom border color
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),  // Rounded corners
        ),
        child: RadioListTile(
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.red,
        ),
      ),
    );
  }
}
