import 'dart:convert';
import 'package:crime_record_management_system/background/background.dart';
import 'package:crime_record_management_system/pages/professionals/authentication/profLogin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../components/button.dart';
import '../../../components/text_field.dart';
import '../../../api/api.dart';

class ProfessionalRegistration extends StatefulWidget {
  const ProfessionalRegistration({Key? key}) : super(key: key);

  @override
  State<ProfessionalRegistration> createState() => _ProfessionalRegistrationState();
}

class _ProfessionalRegistrationState extends State<ProfessionalRegistration> {
  final TextEditingController professionTypeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController organizationNameController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController nidNumberController = TextEditingController();
  final TextEditingController expertiseAreaController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    professionTypeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    organizationNameController.dispose();
    licenseNumberController.dispose();
    nidNumberController.dispose();
    expertiseAreaController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  validateEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.validate_email_prof),
        body: {
          'email': emailController.text.trim(),
        },
      );
      await Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfLogin()),
        );
      });
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['emailFound'] == true) {
          Fluttertoast.showToast(msg: "Email is already in use!");
        } else {
          saveProfessionalRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> saveProfessionalRecord() async {
    try {
      var res = await http.post(
        Uri.parse(API.professionalReg),
        body: {
          'profession_type': professionTypeController.text.trim(),
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'organization_name': organizationNameController.text.trim(),
          'license_number': licenseNumberController.text.trim(),
          'nid_number': nidNumberController.text.trim(),
          'expertise_area': expertiseAreaController.text.trim(),
          'pass': passController.text.trim(),
          'confirm_pass': confirmPassController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        try {
          var resBody = jsonDecode(res.body);
          if (resBody['success'] == true) {
            Fluttertoast.showToast(msg: "You have successfully registered!");
          } else {
            Fluttertoast.showToast(msg: resBody['error'] ?? "An error occurred! Try again.");
          }
        } catch (e) {
          print("Invalid JSON: ${res.body}");
          Fluttertoast.showToast(msg: "Invalid server response. Please try again later.");
        }
      } else {
        print("HTTP Error: ${res.statusCode}");
        Fluttertoast.showToast(msg: "Failed to register. Server error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a common text style for the labels
    const commonTextStyle = TextStyle(
      color: Color(0xFF4A6572), // Navy/teal
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
              const SizedBox(height: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profession Type
                    const Text(
                      "Profession Type",
                      style: commonTextStyle,
                    ),
                    MyTextField(
                      controller: professionTypeController,
                      hintText: "Enter Profession Type (e.g., Police, Detective)",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Profession type is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // First Name
                    const Text(
                      "First Name",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: firstNameController,
                      hintText: "Enter First Name",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Last Name
                    const Text(
                      "Last Name",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: lastNameController,
                      hintText: "Enter Last Name",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Username
                    const Text(
                      "Username",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: usernameController,
                      hintText: "Enter Username",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email
                    const Text(
                      "Email",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: emailController,
                      hintText: "Enter Email",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Organization Name
                    const Text(
                      "Organization Name",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: organizationNameController,
                      hintText: "Enter Organization Name",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    // License Number
                    const Text(
                      "License Number",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: licenseNumberController,
                      hintText: "Enter License Number",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'License number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // NID Number
                    const Text(
                      "NID Number",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: nidNumberController,
                      hintText: "Enter NID Number",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NID number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Expertise Area
                    const Text(
                      "Expertise Area",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: expertiseAreaController,
                      hintText: "Enter Expertise Area",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    // Password
                    const Text(
                      "Password",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: passController,
                      hintText: "Enter Password",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: !showPassword,
                      showToggle: true,
                      onToggle: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password
                    const Text(
                      "Confirm Password",
                      style: commonTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: confirmPassController,
                      hintText: "Confirm Password",
                      fillColors: Colors.grey[100],
                      borderColor: const Color(0xFFB0BEC5),
                      obscureText: !showConfirmPassword,
                      showToggle: true,
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
                    const SizedBox(height: 20),
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
                        height: 50.0,
                        width: double.infinity,
                      ),
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
