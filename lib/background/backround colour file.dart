import 'package:flutter/material.dart';


Widget buildColorExamples() {
  return Column(
    children: [
      Container(
        color: Color.fromRGBO(255, 0, 0, 1.0), // Red
        height: 50,
        width: 200,
        child: Center(child: Text("RGB Red")),
      ),
      SizedBox(height: 10),
      Container(
        color: Color(0xFFFF0000), // Red (hex)
        height: 50,
        width: 200,
        child: Center(child: Text("Hex Red")),
      ),
      SizedBox(height: 10),
      Container(
        color: Colors.blue, // Predefined color
        height: 50,
        width: 200,
        child: Center(child: Text("Blue")),
      ),
      SizedBox(height: 10),
      Scaffold(
        backgroundColor: Colors.grey[200], // light grey scaffold
        body: Center(child: Text("Light Grey Scaffold")),
      ),
      SizedBox(height: 10),
      Material(
        color: Colors.amber,
        child: Container(
          height: 50,
          width: 200,
          child: Center(child: Text("Amber Material")),
        ),
      ),
      SizedBox(height: 10),
      Container(
        color: Color(0x80AABBCC), // 50% opacity of #AABBCC
        height: 50,
        width: 200,
        child: Center(child: Text("50% Opacity")),
      ),
    ],
  );
}

