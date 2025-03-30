import 'package:crime_record_management_system/background/background.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/authentication/peopleRegister.dart';
import 'package:crime_record_management_system/pages/professionals/authentication/proffessionalRegister.dart';
import 'package:flutter/material.dart';
import 'package:crime_record_management_system/components/button.dart';
import 'package:crime_record_management_system/components/selection_tile.dart';


class UserType extends StatefulWidget {
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  String selectedUserType = "";

  void navigateToRegisterPage() {
    if (selectedUserType == "People") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PeopleRegister()));
    } else if (selectedUserType == "Professionals") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfessionalRegistration()));
    } /*else if (selectedUserType == "Shopkeeper") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopkeeperRegister()));
    } else if (selectedUserType == "General People") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralPeopleRegister()));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              const Text(
                "User Selection",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              MySelectionTile(
                title: "People",
                value: "People",
                textColor: Colors.black,
                groupValue: selectedUserType,
                onChanged: (value) {
                  setState(() {
                    selectedUserType = value!;
                  });
                },
                height: 80,
                width: 300,
                backgroundColor: Colors.purpleAccent,
                borderColor: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 10),
              MySelectionTile(
                title: "Professionals",
                value: "Professionals",
                groupValue: selectedUserType,
                onChanged: (value) {
                  setState(() {
                    selectedUserType = value!;
                  });
                },
                height: 80,
                width: 300,
                backgroundColor: Colors.purpleAccent,
                borderColor: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 20),
              MyButton(
                text: "Submit",
                onTap: navigateToRegisterPage,
                height: 45.0,
                width: 120.0,
                color: Colors.purpleAccent,
                borderColor: Colors.transparent,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text(
                      "Log in!",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
