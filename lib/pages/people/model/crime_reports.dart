import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CrimeReport {
  final int id;
  final String title;
  final String description;

  CrimeReport({required this.id, required this.title, required this.description});

  factory CrimeReport.fromJson(Map<String, dynamic> json) {
    return CrimeReport(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}