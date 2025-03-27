import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:crime_record_management_system/pages/professionals/profPreferences/current_professionals.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/professional_preference.dart';
import 'package:flutter/material.dart';

class Profprofilefragmentscreen extends StatefulWidget {
  const Profprofilefragmentscreen({super.key});

  @override
  State<Profprofilefragmentscreen> createState() => _ProfprofilefragmentscreenState();
}

class _ProfprofilefragmentscreenState extends State<Profprofilefragmentscreen> {
  
  final currentProfessional = CurrentProfessional();
  
  void initState() {
    super.initState();
    currentProfessional.getProfessionalInfo();
  }
  
  void logOutProfessional(BuildContext context) async {
    final resultRes = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: const Text(
              "Are you sure?\n You want to log out from the Dollars+?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
