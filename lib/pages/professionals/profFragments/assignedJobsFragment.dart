import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../api/api.dart';
import '../profPreferences/current_professionals.dart';

class AssignedJobsFragmentScreen extends StatefulWidget {
  final int professionalId;

  const AssignedJobsFragmentScreen({super.key, required this.professionalId});

  @override
  _AssignedJobsFragmentScreenState createState() => _AssignedJobsFragmentScreenState();
}

class _AssignedJobsFragmentScreenState extends State<AssignedJobsFragmentScreen> {
  List<dynamic> _assignedJobs = [];
  final currentProfessional = CurrentProfessional();
  @override
  void initState() {
    super.initState();
    currentProfessional.getProfessionalInfo();
    _fetchAssignedJobs();
  }

  Future<void> _fetchAssignedJobs() async {
    try {
      final response = await http.post(
        Uri.parse(API.fetchAssignedJobs),
        body: {
          'professional_id': currentProfessional.professionalId.toString(),
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _assignedJobs = data['jobs'] ?? [];
          });
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to load assigned jobs. Please try again.");
      }
    } catch (e) {
      print("Error fetching assigned jobs: $e");
      Fluttertoast.showToast(msg: "An error occurred while fetching jobs.");
    }
  }


  Future<void> _updateJobProgress(int jobId, double progress) async {
    try {
      final response = await http.post(
        Uri.parse(API.updateAssignedJobs),
        body: {
          'job_id': jobId.toString(),
          'progress': progress.toString(),
        },
      );

      print("Update job response: ${response.body}");
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        Fluttertoast.showToast(msg: "Job progress updated successfully.");
        if (progress == 100) _fetchAssignedJobs(); // Refresh jobs if a job is completed
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      print("Error updating job progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Jobs"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: _assignedJobs.isEmpty
          ? const Center(
        child: Text(
          "No assigned jobs found.",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        itemCount: _assignedJobs.length,
        itemBuilder: (context, index) {
          final job = _assignedJobs[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job ID: ${job['id']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Description: ${job['description']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: job['progress'] / 100,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Progress:", style: TextStyle(color: Colors.white70)),
                      Text("${job['progress']}%", style: const TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  Slider(
                    value: job['progress'].toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: "${job['progress']}%",
                    onChanged: (value) {
                      setState(() {
                        job['progress'] = value.toInt(); // Update locally
                      });
                    },
                    onChangeEnd: (value) {
                      _updateJobProgress(job['id'], value); // Update on server
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
