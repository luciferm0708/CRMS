import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:http/http.dart' as http;
import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import '../../api/api.dart';
import '../people/model/people.dart';

class ProfileFragmentScreen extends StatefulWidget {
  @override
  _ProfileFragmentScreenState createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  final CurrentUser _currentPeople = Get.put(CurrentUser());
  File? _profileImage; // For mobile builds
  XFile? _pickedFile; // For web builds

  @override
  void initState() {
    super.initState();
    _currentPeople.getPeopleInfo(); // Fetch user data on initialization
  }

  Future<void> uploadProfileImage(XFile pickedFile) async {
    try {
      final uri = Uri.parse(API.peoproImg);
      final request = http.MultipartRequest('POST', uri);

      if (File(pickedFile.path).existsSync()) {
        print("Image path: ${pickedFile.path}");
        request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));
      } else {
        print("File does not exist.");
        return;
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile; // Store picked file for later use
          _profileImage = File(pickedFile.path); // For non-web builds
        });
        await uploadProfileImage(pickedFile); // Pass XFile for upload
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void logOutPeople(BuildContext context) async {
    var resultRes = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            "Log Out",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            "Are you sure?\nYou want to logout from the CRMS?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop("loggedOut");
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (resultRes == "loggedOut") {
      await PeoplePref.removePeopleInfo();
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
              (Route<dynamic> route) => false,
        );
      });
    }
  }

  Widget peopleInfoItemProfile(IconData iconData, String peopleData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              peopleData,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<People>(
        valueListenable: _currentPeople.currentPeople,
        builder: (context, people, child) {
          if (people.username.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: ParticlesFly(
                  height: size.height,
                  width: size.width,
                  connectDots: true,
                  numberOfParticles: 50,
                ),
              ),
              ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  SizedBox(height: size.height * 0.1),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!) // For mobile builds
                                : _pickedFile != null
                                ? NetworkImage(_pickedFile!.path) // For web builds
                                : const AssetImage('assets/crms.png'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Tap to change profile picture",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  peopleInfoItemProfile(Icons.person, people.username),
                  const SizedBox(height: 20),
                  peopleInfoItemProfile(Icons.email, people.email),
                  const SizedBox(height: 20),
                  peopleInfoItemProfile(Icons.perm_identity, people.nid?.toString() ?? ''),
                  const SizedBox(height: 20),
                  peopleInfoItemProfile(Icons.date_range, people.dob ?? ''),
                  const SizedBox(height: 20),
                  Center(
                    child: Material(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          logOutPeople(context);
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          child: Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
