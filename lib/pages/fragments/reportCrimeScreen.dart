import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../people/preferences/current_user.dart';
import '../../api/api.dart';
import 'package:particles_fly/particles_fly.dart';

import 'home.dart';

class ReportCrimeScreen extends StatefulWidget {
  final VoidCallback onReportSubmitted;

  ReportCrimeScreen({required this.onReportSubmitted});

  @override
  _ReportCrimeScreenState createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  final _descriptionController = TextEditingController();
  String _selectedForum = "Mirpur";
  List<Uint8List> _imageDataList = [];
  bool _isSubmitting = false; // Submission loading indicator

  final _forums = ["Mirpur", "Mohammadpur", "Savar"];
  final currentUser = CurrentUser();

  @override
  void initState() {
    super.initState();
    currentUser.getPeopleInfo();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageDataList.add(imageBytes);
        });
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

    setState(() => _isSubmitting = true);

    try {
      String peopleId = currentUser.currentPeople.value.people_id.toString();
      String userName = currentUser.currentPeople.value.username;

      final uri = Uri.parse(API.report);
      var request = http.MultipartRequest('POST', uri);
      request.fields['people_id'] = peopleId;
      request.fields['username'] = userName;
      request.fields['forum'] = _selectedForum;
      request.fields['description'] = _descriptionController.text;

      for (var i = 0; i < _imageDataList.length; i++) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image[]',
          _imageDataList[i],
          filename: 'uploaded_image_$i.jpg',
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Crime report submitted successfully!")),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(), // Replace with a valid screen
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit report: $responseBody")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Report Crime"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: ParticlesFly(
              height: size.height,
              width: size.width,
              connectDots: true,
              numberOfParticles: 50,
            ),
          ),
          if (_isSubmitting)
            Center(child: CircularProgressIndicator()), // Loading indicator
          if (!_isSubmitting)
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
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    _imageDataList.isEmpty
                        ? Text("No images selected", style: TextStyle(color: Colors.white))
                        : Column(
                      children: _imageDataList.map((imageBytes) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.memory(imageBytes, height: 150),
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
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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