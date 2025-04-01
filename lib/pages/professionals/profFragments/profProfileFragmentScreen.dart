import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crime_record_management_system/pages/logInInterface.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/current_professionals.dart';
import 'package:crime_record_management_system/pages/professionals/profPreferences/professional_preference.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../../api/api.dart';
import '../model/professional.dart';

class ProfProfileFragmentScreen extends StatefulWidget {
  const ProfProfileFragmentScreen({super.key});

  @override
  State<ProfProfileFragmentScreen> createState() => _ProfProfileFragmentScreenState();
}

class _ProfProfileFragmentScreenState extends State<ProfProfileFragmentScreen> {

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final currentProfessional = CurrentProfessional();
  
  @override
  void initState() {
    super.initState();
    currentProfessional.getProfessionalInfo();
  }

  /*Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // Get professional data
      final professional = currentProfessional.currentProfessional.value;
      final professionalId = professional.professionalId.toString();

      // Prepare multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.uploadProfProfileImage),
      );

      // Add file
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'profile_image',
          bytes,
          filename: image.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          image.path,
        ));
      }

      // Add fields
      request.fields['professional_id'] = professionalId;

      // Send request
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(respStr);

      if (response.statusCode == 200 && jsonResponse['success']) {
        // Update local state
        setState(() {
          professional.profileImage = jsonResponse['image_url'];
          currentProfessional.currentProfessional.value = professional;
        });

        // Update shared preferences
        await ProfessionalPref.storeProfessionalInfo(professional);

        // Force UI refresh
        currentProfessional.currentProfessional.notifyListeners();
      } else {
        throw Exception(jsonResponse['message'] ?? 'Upload failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${e.toString()}')),
      );
      if (kDebugMode) print("Upload error: $e");
    }
  }*/
  Future<void> _uploadImage() async {
    try {
      if (kIsWeb) {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;

        final bytes = await image.readAsBytes();
        final professional = currentProfessional.currentProfessional.value;

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(API.uploadProfProfileImage),
        );

        request.files.add(http.MultipartFile.fromBytes(
          'profile_image',
          bytes,
          filename: image.name,
        ));
        request.fields['professional_id'] = professional.professionalId.toString();

        var response = await request.send();
        if (response.statusCode == 200) {
          final imageUrl = await response.stream.bytesToString();
          setState(() {
            professional.profileImage = imageUrl;
            currentProfessional.currentProfessional.value = professional;
          });
          await ProfessionalPref.storeProfessionalInfo(professional);
        }
      } else {
        // Mobile platform handling
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            final status = await Permission.photos.request();
            if (status.isPermanentlyDenied) {
              await openAppSettings();
              return;
            }
            if (!status.isGranted) return;
          } else {
            final status = await Permission.storage.request();
            if (status.isPermanentlyDenied) {
              await openAppSettings();
              return;
            }
            if (!status.isGranted) return;
          }
        } else if (Platform.isIOS) {
          final status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            await openAppSettings();
            return;
          }
          if (!status.isGranted) return;
        }

        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          requestFullMetadata: !kIsWeb,
        );

        if (image == null) return;

        setState(() => _profileImage = File(image.path));

        final professional = currentProfessional.currentProfessional.value;
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(API.uploadProfProfileImage),
        );

        request.files.add(
          await http.MultipartFile.fromPath("profile_image", image.path),
        );
        request.fields['professional_id'] = professional.professionalId.toString();

        var response = await request.send();
        if (response.statusCode == 200) {
          final imageUrl = await response.stream.bytesToString();
          setState(() {
            professional.profileImage = imageUrl;
            currentProfessional.currentProfessional.value = professional;
          });
          await ProfessionalPref.storeProfessionalInfo(professional);
        }
      }
    } catch (e) {
      if (kDebugMode) print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
      );
      setState(() => _profileImage = null);
    }
  }

  void logOutProfessional(BuildContext context) async {
    final resultRes = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: const Text(
              "Are you sure?\n You want to log out from the Dollars+?",
              style: TextStyle(
                color: Colors.white,
              ),
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
              )
            ],
          );
        }
    );

    if (resultRes == "loggedOut") {
      await ProfessionalPref.removeProfessionalInfo();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Logininterface()),
            (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildProfileImage(Professional professional) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: _uploadImage,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[800],
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : (professional.profileImage?.isNotEmpty ?? false
                ? CachedNetworkImageProvider(professional.profileImage!)
                : null),
            child: _profileImage == null &&
                (professional.profileImage?.isEmpty ?? true)
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Colors.white),
            onPressed: _uploadImage,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
        ),
      ],
    );
  }

  Widget profInfoItemProfile(IconData iconData, String profData) {
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
          const SizedBox(width: 16,),
          Expanded(
              child: Text(
                profData,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<Professional>(
        valueListenable: currentProfessional.currentProfessional,
        builder: (context, professional, child) {
          if (professional.username.isEmpty) {
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
                  _buildProfileImage(professional),
                  const SizedBox(height: 40,),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.person, professional.username),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.email, professional.email),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.onetwothree_sharp, professional.nidNumber?.toString() ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.text_format_sharp, professional.organizationName ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.onetwothree_sharp, professional.licenseNumber ?? ''),
                      const SizedBox(height: 20),
                      profInfoItemProfile(Icons.text_snippet_sharp, professional.professionType),
                      const SizedBox(height: 20),
                      Center(
                        child: Material(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              logOutProfessional(context);
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
              ),
            ],
          );
        },
      ),
    );
  }
}