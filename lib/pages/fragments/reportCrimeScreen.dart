import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:particles_fly/particles_fly.dart';

import '../../api/api.dart';
import 'homeFragmentScreen.dart';

class ReportCrimeScreen extends StatefulWidget {
  @override
  _ReportCrimeScreenState createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  final _descriptionController = TextEditingController();
  String _selectedForum = "Mirpur";
  List<Uint8List> _imageDataList = []; // To store multiple images

  final _forums = ["Mirpur", "Mohammadpur", "Savar"];

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes(); // Read image as bytes
        setState(() {
          _imageDataList.add(imageBytes); // Add image to the list
        });
        print("Image selected: ${pickedFile.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    if (_descriptionController.text.isEmpty || _selectedForum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    try {
      final uri = Uri.parse(API.report);
      print('API Endpoint: $uri');

      var request = http.MultipartRequest('POST', uri);
      request.fields['people_id'] = "1"; // Replace with logged-in user's ID
      request.fields['forum'] = _selectedForum;
      request.fields['description'] = _descriptionController.text;

      if (_imageDataList.isNotEmpty) {
        for (var i = 0; i < _imageDataList.length; i++) {
          var multipartFile = http.MultipartFile.fromBytes(
            'image[]', // Use consistent key for all images
            _imageDataList[i],
            filename: 'uploaded_image_$i.jpg',
          );
          request.files.add(multipartFile);
        }
        print("${_imageDataList.length} images attached to request.");
      } else {
        print("No images attached.");
      }

      print("Submitting report...");
      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      print("Server Response: $responseBody");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Crime report submitted successfully!")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeFragmentScreen()),
              (route) => false, // Clears the navigation stack
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit report: $responseBody")),
        );
      }
    } catch (e) {
      print("Error submitting report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get the screen size

    return Scaffold(
      appBar: AppBar(
        title: Text("Report Crime"),
        backgroundColor: Colors.black, // Set AppBar background to black
        elevation: 2.0, // Slight shadow for better appearance
      ),
      backgroundColor: Colors.black, // Set Scaffold background to black
      body: Stack(
        children: [
          // Background particle effect
          Positioned.fill(
            child: ParticlesFly(
              height: size.height,
              width: size.width,
              connectDots: true,
              numberOfParticles: 50,
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedForum,
                    items: _forums.map((forum) {
                      return DropdownMenuItem(
                        value: forum,
                        child: Text(forum, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedForum = value!),
                    decoration: InputDecoration(
                      labelText: "Select Forum",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Crime Description",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800], // Dark gray background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // White text
                  ),
                  SizedBox(height: 16),
                  _imageDataList.isEmpty
                      ? Text(
                    "No images selected",
                    style: TextStyle(color: Colors.white),
                  )
                      : Column(
                    children: _imageDataList.map((imageBytes) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.memory(
                          imageBytes,
                          height: 150,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.image, color: Colors.white),
                    label: Text("Pick Image", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _pickImage,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      "Submit Report",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Red color for prominence
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _submitReport(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:particles_fly/particles_fly.dart';

import '../../api/api.dart';

class ReportCrimeScreen extends StatefulWidget {
  @override
  _ReportCrimeScreenState createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  final _descriptionController = TextEditingController();
  String _selectedForum = "Mirpur";
  Uint8List? _imageData; // To store the image bytes

  final _forums = ["Mirpur", "Mohammadpur", "Savar"];

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes(); // Read image as bytes
        setState(() {
          _imageData = imageBytes;
        });
        print("Image selected: ${pickedFile.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    if (_descriptionController.text.isEmpty || _selectedForum.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    try {
      final uri = Uri.parse(API.report);
      print('API Endpoint: $uri');

      var request = http.MultipartRequest('POST', uri);
      request.fields['people_id'] = "1"; // Replace with logged-in user's ID
      request.fields['forum'] = _selectedForum;
      request.fields['description'] = _descriptionController.text;

      if (_imageData != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image',
          _imageData!,
          filename: 'uploaded_image.jpg', // Default filename
        );
        request.files.add(multipartFile);
        print("Image attached to request.");
      } else {
        print("No image attached.");
      }

      print("Submitting report...");
      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      print("Server Response: $responseBody");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Crime report submitted successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit report: $responseBody")),
        );
      }
    } catch (e) {
      print("Error submitting report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get the screen size

    return Scaffold(
      appBar: AppBar(title: Text("Report Crime")),
      body: Stack(
        children: [
          // Background particle effect
          Positioned.fill(
            child: ParticlesFly(
              height: size.height,
              width: size.width,
              connectDots: true,
              numberOfParticles: 50,
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedForum,
                    items: _forums.map((forum) {
                      return DropdownMenuItem(
                        value: forum,
                        child: Text(forum),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedForum = value!),
                    decoration: InputDecoration(
                      labelText: "Select Forum",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Crime Description",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  _imageData == null
                      ? Text(
                    "No image selected",
                    style: TextStyle(color: Colors.white),
                  )
                      : Image.memory(
                    _imageData!,
                    height: 150,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Pick Image"),
                    onPressed: _pickImage,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Submit Report"),
                    onPressed: () => _submitReport(context),  // Pass context here
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 */