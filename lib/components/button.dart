import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double height;
  final double width;
  final Color color;  // Button background color
  final Color borderColor;  // New border color parameter

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 50.0,  // Default height
    this.width = 150.0,  // Default width
    this.color = Colors.blue,  // Default button color
    this.borderColor = Colors.blueAccent,  // Default border color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          decoration: BoxDecoration(
            color: color,  // Button background color
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,  // Shadow color
                offset: Offset(4, 4),   // Shadow position
                blurRadius: 8,          // Shadow blur radius
              ),
            ],
            border: Border.all(
              color: borderColor,  // Use the passed border color here
              width: 2.0,          // Border thickness
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
