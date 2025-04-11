import 'dart:convert';

import 'package:crime_record_management_system/background/background.dart';
import 'package:crime_record_management_system/pages/fragments/homeFragmentScreen.dart';
import 'package:crime_record_management_system/pages/professionals/profFragments/profHome.dart';
import 'package:crime_record_management_system/pages/professionals/profFragments/profHomeFragmentScreen.dart';
import 'package:crime_record_management_system/pages/userType.dart';
import 'package:flutter/material.dart';
import 'package:crime_record_management_system/components/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/button.dart';
import '../../../api/api.dart';
import '../../fragments/home.dart';
import 'package:http/http.dart' as http;

import '../model/professional.dart';
import '../profPreferences/professional_preference.dart';

class ProfLogin extends StatefulWidget {
  const ProfLogin({super.key});

  @override
  State<ProfLogin> createState() => _LoginState();
}

class _LoginState extends State<ProfLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool showPassword = false;

  // Define a GlobalKey for the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  loginProf() async {
    try {
      var res = await http.post(
        Uri.parse(API.prof_login),
        body: {
          "email": emailController.text.trim(),
          "pass": passController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyLogIn = jsonDecode(res.body);
        if (resBodyLogIn['success'] == true) {
          Fluttertoast.showToast(msg: "You are Logged In!");

          Professional professionalInfo = Professional.fromJson(resBodyLogIn["professionalData"]);
          await ProfessionalPref.storeProfessionalInfo(professionalInfo);

          await Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfHome(),)
            );
          });

        } else {
          Fluttertoast.showToast(msg: "Incorrect credentials! Try again.");
        }
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/crms.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 50),
              const Text(
                "Welcome",
                style: TextStyle(
                  color: Color(0xFF2D4059), // Navy blue
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xFF4A6572), // Slate grey
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    MyTextField(
                        controller: emailController,
                        hintText: "Enter email",
                        fillColors: Colors.grey[100],
                        borderColor: Color(0xFFB0BEC5), // Light blue-grey
                        obscureText: false,
                        validator: (value) {/* keep validation */}
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Color(0xFF4A6572), // Slate grey
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    MyTextField(
                        controller: passController,
                        hintText: "Enter password",
                        fillColors: Colors.grey[100],
                        borderColor: Color(0xFFB0BEC5), // Light blue-grey
                        obscureText: !showPassword,
                        showToggle: true,
                        onToggle: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        validator: (value) {/* keep validation */}
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF5C8D89), // Muted teal
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: MyButton(
                        text: 'Log in!',
                        color: Color(0xFF5C8D89), // Muted teal
                        borderColor: Color(0xFF445A67), // Darker teal
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            loginProf();
                          }
                        },
                        height: 50.0,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not an user? ",
                          style: TextStyle(color: Color(0xFF4A6572)), // Slate grey
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserType()),
                            );
                          },
                          child: const Text(
                            "Register now!",
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
            ],
          ),
        ),
      ),
    );
  }
}
