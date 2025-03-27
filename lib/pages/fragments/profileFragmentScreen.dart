import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:http/http.dart' as http;
import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import '../../api/api.dart';
import '../people/model/people.dart';
import 'dart:typed_data';

class ProfileFragmentScreen extends StatefulWidget {
  const ProfileFragmentScreen({super.key});

  @override
  _ProfileFragmentScreenState createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  final CurrentUser _currentPeople = Get.put(CurrentUser());
  List<Uint8List> _imageDataList = [];
  File? _selectedImage; // To hold the selected image file

  @override
  @override
  void initState() {
    super.initState();
    _currentPeople.getPeopleInfo();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    final savedImageUrl = await PeoplePref.getProfileImageUrl(); // Fetch saved URL
    if (savedImageUrl != null) {
      setState(() {
        _currentPeople.updateProfileImageUrl(savedImageUrl); // Update observable
      });
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      if (_imageDataList.isEmpty) {
        Fluttertoast.showToast(msg: "No images selected for upload.");
        return;
      }

      final uri = Uri.parse(API.peoproImg);
      final request = http.MultipartRequest('POST', uri);

      for (var i = 0; i < _imageDataList.length; i++) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // Match the PHP script's key
          _imageDataList[i],
          filename: 'uploaded_image_$i.jpg',
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final responseJson = json.decode(responseData.body);

        if (responseJson['status'] == 'success') {
          final uploadedImageUrl = responseJson['data'][0]; // Use the first URL
          await PeoplePref.saveProfileImageUrl(uploadedImageUrl); // Save URL persistently
          setState(() {
            _currentPeople.updateProfileImageUrl(uploadedImageUrl); // Update observable
          });
          Fluttertoast.showToast(msg: "Profile image updated successfully!");
        } else {
          Fluttertoast.showToast(msg: "Failed to upload images: ${responseJson['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "Error uploading image. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading images: $e");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          // Web-specific handling
          final imageData = await pickedFile.readAsBytes(); // Perform async operation first
          setState(() {
            _imageDataList.add(imageData); // Update state synchronously
          });
        } else {
          // Mobile-specific handling
          final imageFile = File(pickedFile.path);
          setState(() {
            _selectedImage = imageFile; // Update state synchronously
            _imageDataList.add(imageFile.readAsBytesSync());
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void logOutPeople(BuildContext context) async {
    final resultRes = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Log Out",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: const Text(
            "Are you sure?\nYou want to log out from the CRMS?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop("loggedOut");
              },
              child: const Text(
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false,
      );
    }
  }

  Widget peopleInfoItemProfile(IconData iconData, String peopleData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              style: const TextStyle(fontSize: 15, color: Colors.white),
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
            return const Center(child: CircularProgressIndicator());
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
                            backgroundImage: _currentPeople.profileImageUrl.value.isNotEmpty
                                ? NetworkImage(_currentPeople.profileImageUrl.value)
                                : AssetImage('assets/crms.png') as ImageProvider,
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
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          child: Text(
                            "Log Out",
                            style: TextStyle(color: Colors.black, fontSize: 16),
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
