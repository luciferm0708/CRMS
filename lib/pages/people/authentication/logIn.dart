import 'dart:convert';

import 'package:crime_record_management_system/background/background.dart';
import 'package:crime_record_management_system/pages/userType.dart';
import 'package:flutter/material.dart';
import 'package:crime_record_management_system/components/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../api/api.dart';
import '../../../components/button.dart';
import '../model/people.dart';
import '../../fragments/home.dart';

import 'package:http/http.dart' as http;

import '../preferences/people_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool showPassword = false;

  // Define a GlobalKey for the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  loginPeople() async {
    try {
      var res = await http.post(
        Uri.parse(API.logIn),
        body: {
          "email": emailController.text.trim(),
          "pass": passController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyLogIn = jsonDecode(res.body);
        if (resBodyLogIn['success'] == true) {
          Fluttertoast.showToast(msg: "You are Logged In!");

          People peopleInfo = People.fromJson(resBodyLogIn["peopleData"]);
          await PeoplePref.storePeopleInfo(peopleInfo);

          await Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
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
          key: formKey,  // Associate the form key with the Form widget
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
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
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
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: emailController,
                      hintText: "Enter email",
                      fillColors: Colors.purpleAccent,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: passController,
                      hintText: "Enter password",
                      obscureText: !showPassword,
                      showToggle: true,
                      fillColors: Colors.purpleAccent,
                      onToggle: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: MyButton(
                        text: 'Log in!',
                        color: Colors.deepPurple,
                        borderColor: Colors.transparent,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            loginPeople();
                          }
                        },
                        height: 45.0,  // Custom height
                        width: 120.0,  // Custom width
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not an user?",
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserType()),
                            );
                          },
                          child: const Text(
                            "Register now!",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
