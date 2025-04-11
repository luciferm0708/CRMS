// tab_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'customDrawer.dart';
// Import other fragment pages as needed (e.g. privacy_fragment_screen.dart, settings_fragment_screen.dart, etc.)

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final CurrentUser _currentPeople = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    _currentPeople.getPeopleInfo();
  }

  @override
  Widget build(BuildContext context) {
    // This screen will only show a drawer (no content in the body).
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Title"),
        backgroundColor: const Color(0xFF4A6572),
      ),
      drawer: CustomDrawer(currentPeople: _currentPeople),
      body: Container(), // empty body; all navigation happens through the drawer
    );
  }
}
