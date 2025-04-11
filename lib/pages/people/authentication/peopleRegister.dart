import 'dart:convert';
import 'package:crime_record_management_system/background/background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../api/api.dart';
import '../../../components/button.dart';
import '../model/people.dart';
import '../../../components/text_field.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'logIn.dart';

class PeopleRegister extends StatefulWidget {
  const PeopleRegister({super.key});

  @override
  State<PeopleRegister> createState() => _PeopleRegisterState();
}

class _PeopleRegisterState extends State<PeopleRegister> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nidController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
    nidController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.dispose();
  }

  validateEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'email': emailController.text.trim(),
        },
      );
      await Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['emailFound'] == true) {
          Fluttertoast.showToast(msg: "Email is already in use!");
        } else {
          saveRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveRecord() async {
    People peopleModel = People(
      1,
      firstnameController.text.trim(),
      lastnameController.text.trim(),
      usernameController.text.trim(),
      emailController.text.trim(),
      genderController.text.trim(),
      int.tryParse(nidController.text.trim()) ?? 0, // Safe conversion
      dobController.text.trim(),
      passController.text.trim(),
      confirmPassController.text.trim(),
    );

    print('Sending data: ${peopleModel.toJson()}'); // Debug payload

    try {
      var res = await http.post(
        Uri.parse(API.peopleRegister),
        body: peopleModel.toJson(),
      );
      print('Response: ${res.body}');

      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Fluttertoast.showToast(msg: "You have successfully registered!");
        } else {
          Fluttertoast.showToast(msg: "An error occurred! Try again.");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a common text style for all the labels
    const commonTextStyle = TextStyle(
      color: Color(0xFF4A6572), // Navy/teal color
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );

    return BackGround(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/crms.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 5),
              const Text(
                "Let's create an account",
                style: TextStyle(
                  color: Color(0xFF2D4059), // Navy blue
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Name
                      const Text(
                        "First Name",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: firstnameController,
                        hintText: "Enter First Name",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Last Name
                      const Text(
                        "Last Name",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: lastnameController,
                        hintText: "Enter Last Name",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Username
                      const Text(
                        "Username",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: usernameController,
                        hintText: "Enter Username",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Gender
                      const Text(
                        "Gender",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: genderController,
                        hintText: "Enter Gender",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // NID
                      const Text(
                        "NID",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: nidController,
                        hintText: "Enter NID",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your NID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Date of Birth
                      const Text(
                        "Date of Birth",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: dobController,
                        hintText: "Select Date of Birth",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        readOnly: true,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today, color: Colors.black),
                          onPressed: () => _selectDate(context),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Email
                      const Text(
                        "Email",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: emailController,
                        hintText: "Enter email",
                        obscureText: false,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Password
                      const Text(
                        "Password",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: passController,
                        hintText: "Enter password",
                        obscureText: !showPassword,
                        showToggle: true,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
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
                      // Confirm Password
                      const Text(
                        "Confirm Password",
                        style: commonTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      MyTextField(
                        controller: confirmPassController,
                        hintText: "Re-enter password",
                        obscureText: !showConfirmPassword,
                        showToggle: true,
                        fillColors: Colors.grey[100],
                        borderColor: const Color(0xFFB0BEC5),
                        onToggle: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != passController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: MyButton(
                          text: 'Register',
                          color: const Color(0xFF5C8D89), // Muted teal
                          borderColor: const Color(0xFF445A67), // Darker teal
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              validateEmail();
                            }
                          },
                          height: 45,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already a user?",
                            style: commonTextStyle,
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Login()),
                              );
                            },
                            child: const Text(
                              "Log in!",
                              style: commonTextStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
