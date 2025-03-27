import 'package:crime_record_management_system/pages/professionals/profFragments/assignedJobsFragment.dart';
import 'package:crime_record_management_system/pages/professionals/profFragments/profHomeFragmentScreen.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/current_professionals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfHome extends StatefulWidget {
  const ProfHome({super.key});

  @override
  State<ProfHome> createState() => _ProfHomeState();
}

class _ProfHomeState extends State<ProfHome> {
  CurrentProfessional _rememberCurrentProfessional = Get.put(CurrentProfessional());

  // List of screens to navigate to
  final List<Widget> _fragmentScreens = [
    ProfessionalHomeFragmentScreen(professionalId: Get.find<CurrentProfessional>().professionalId),

    AssignedJobsFragmentScreen(professionalId: Get.find<CurrentProfessional>().professionalId),
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
      "active_icon": Icons.join_full,
      "non_active_icon": Icons.join_full_outlined,
      "label": "Job",
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