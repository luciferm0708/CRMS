import 'package:crime_record_management_system/pages/fragments/homeFragmentScreen.dart';
import 'package:crime_record_management_system/pages/fragments/profileFragmentScreen.dart';
import 'package:crime_record_management_system/pages/fragments/reportCrimeScreen.dart';
import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CurrentUser _rememberCurrentPeople = Get.put(CurrentUser());

  // List of screens to navigate to
  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    ProfileFragmentScreen(),
    ReportCrimeScreen(),
  ];

  // List of navigation button properties
  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile",
    },
    {
      "active_icon": Icons.report,
      "non_active_icon": Icons.report_outlined,
      "label": "Report",
    },
  ];

  // Reactive variable for the current index
  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.black, // Ensure the container has a black background
        child: Obx(() => _fragmentScreens[_indexNumber.value]), // Dynamically switch screen
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          backgroundColor: Colors.red, // Set navigation bar background color to black
          currentIndex: _indexNumber.value, // Use value directly
          onTap: (value) {
            _indexNumber.value = value; // Update the value
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.deepPurple,
          items: List.generate(_navigationButtonsProperties.length, (index) {
            var navBtnProperty = _navigationButtonsProperties[index];
            return BottomNavigationBarItem(
              icon: Icon(navBtnProperty["non_active_icon"]),
              activeIcon: Icon(navBtnProperty["active_icon"]),
              label: navBtnProperty["label"],
            );
          }),
        ),
      ),
    );
  }
}
