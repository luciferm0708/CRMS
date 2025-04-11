import 'package:crime_record_management_system/background/background.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/professionals/authentication/profLogin.dart';
import 'package:crime_record_management_system/pages/userType.dart';
import 'package:flutter/material.dart';
import 'package:crime_record_management_system/components/button.dart';
import 'package:crime_record_management_system/components/selection_tile.dart';


class Logininterface extends StatefulWidget {
  const Logininterface({super.key});

  @override
  State<Logininterface> createState() => _LogininterfaceState();
}


class _LogininterfaceState extends State<Logininterface> {
  String selectedUserType = "";

  void navigateToRegisterPage() {
    if (selectedUserType == "People") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    } else if (selectedUserType == "Professionals") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Select User Type",
              style: TextStyle(
                color: Color(0xFF2D4059), // Navy blue
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            MySelectionTile(
              title: "People",
              value: "People",
              groupValue: selectedUserType,
              onChanged: (value) => setState(() => selectedUserType = value!),
              height: 80,
              width: 300,
              backgroundColor: Color(0xFF5C8D89).withOpacity(0.1), // Teal overlay
              borderColor: Color(0xFF5C8D89), // Muted teal
              textColor: Color(0xFF2D4059), // Navy text
            ),
            const SizedBox(height: 15),
            MySelectionTile(
              title: "Professionals",
              value: "Professionals",
              groupValue: selectedUserType,
              onChanged: (value) => setState(() => selectedUserType = value!),
              height: 80,
              width: 300,
              backgroundColor: Color(0xFF5C8D89).withOpacity(0.1),
              borderColor: Color(0xFF5C8D89),
              textColor: Color(0xFF2D4059),
            ),
            const SizedBox(height: 30),
            MyButton(
              text: "Continue",
              onTap: navigateToRegisterPage,
              height: 50,
              width: 200,
              color: Color(0xFF5C8D89), // Muted teal
              borderColor: Color(0xFF445A67), // Darker teal
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New user? ",
                  style: TextStyle(color: Color(0xFF4A6572)), // Slate grey
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserType()),
                  ),
                  child: const Text(
                    "Create account",
                    style: TextStyle(
                      color: Color(0xFF5C8D89), // Muted teal
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
