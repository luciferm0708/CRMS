// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/model/people.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'homeFragmentScreen.dart';
// Import other fragment pages as needed

class CustomDrawer extends StatelessWidget {
  final CurrentUser currentPeople;
  const CustomDrawer({Key? key, required this.currentPeople}) : super(key: key);

  // Common text style for drawer items
  static const commonTextStyle = TextStyle(
    color: Color(0xFF4A6572), // Soothing navy/teal
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  // Helper to build a drawer item that pushes to the given fragment page.
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A6572)),
      title: Text(title, style: commonTextStyle),
      onTap: () {
        // Close the drawer and push the fragment page
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  // Log out handler
  Future<void> _logOutPeople(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Log Out",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
              const Text("No", style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop("loggedOut"),
              child: const Text("Yes",
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    if (result == "loggedOut") {
      await PeoplePref.removePeopleInfo();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFa1c4fd), Color(0xFFc2e9fb)], // Soft blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ValueListenableBuilder<People>(
            valueListenable: currentPeople.currentPeople,
            builder: (context, people, child) {
              return DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFcfd9df), Color(0xFFe2ebf0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    people.username.isEmpty
                        ? "Welcome, User"
                        : "Welcome, ${people.username}",
                    style: const TextStyle(
                      color: Color(0xFF4A6572),
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          // Drawer items to push to different fragment pages.
          _buildDrawerItem(
            context: context,
            icon: Icons.home,
            title: "Home",
            destination: HomeFragmentScreen(),
          ),
          // Add additional drawer items here as needed. For example:
          // _buildDrawerItem(
          //   context: context,
          //   icon: Icons.privacy_tip,
          //   title: "Privacy & Policy",
          //   destination: PrivacyFragmentScreen(),
          // ),
          // _buildDrawerItem(
          //   context: context,
          //   icon: Icons.settings,
          //   title: "Settings",
          //   destination: SettingsFragmentScreen(),
          // ),
          // _buildDrawerItem(
          //   context: context,
          //   icon: Icons.help_outline,
          //   title: "Help & Support",
          //   destination: HelpSupportFragmentScreen(),
          // ),
          // _buildDrawerItem(
          //   context: context,
          //   icon: Icons.info_outline,
          //   title: "About",
          //   destination: AboutFragmentScreen(),
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Log Out",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w600)),
            onTap: () => _logOutPeople(context),
          ),
        ],
      ),
    );
  }
}
