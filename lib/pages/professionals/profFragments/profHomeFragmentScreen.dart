import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:particles_fly/particles_fly.dart';
import '../../../api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfessionalHomeFragmentScreen extends StatefulWidget {
  final int professionalId;

  const ProfessionalHomeFragmentScreen({Key? key, required this.professionalId}) : super(key: key);

  @override
  _ProfessionalHomeFragmentScreenState createState() => _ProfessionalHomeFragmentScreenState();
}

class _ProfessionalHomeFragmentScreenState extends State<ProfessionalHomeFragmentScreen> {
  List<dynamic> _reports = [];
  String _selectedForum = "All";
  final _forums = ["All", "Mirpur", "Mohammadpur", "Savar"];

  @override
  void initState() {
    super.initState();
    _fetchReports(); // Fetch reports when the screen is loaded
  }

  Future<void> _fetchReports() async {
    try {
      final response = await http.get(Uri.parse(API.fetchReports));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _reports = data['reports']; // Update _reports with fetched data
          });
        } else {
          print("Failed to fetch reports: ${data['message']}");
        }
      } else {
        print("Failed to load reports: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching reports: $e");
    }
  }

  Future<void> _assignJob(int reportId) async {
    try {
      final response = await http.post(
        Uri.parse(API.assign_crime),
        body: {
          'report_id': reportId.toString(),
          'professional_id': widget.professionalId.toString(),
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['success']) {
            Fluttertoast.showToast(msg: "Job assigned successfully!");
          } else {
            Fluttertoast.showToast(msg: data['message']);
          }
        } catch (jsonError) {
          print("Non-JSON response: ${response.body}");
          Fluttertoast.showToast(msg: "Unexpected response format.");
        }
      } else {
        print("Response body: ${response.body}");
        Fluttertoast.showToast(msg: "Failed to assign job. Server error.");
      }
    } catch (e) {
      print("Error assigning job: $e");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Filter reports by forum
    List<dynamic> filteredReports = _selectedForum == "All"
        ? _reports
        : _reports.where((report) => report['forum'] == _selectedForum).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Professional Dashboard"),
        backgroundColor: Colors.black,
        actions: [
          DropdownButton<String>(
            value: _selectedForum,
            dropdownColor: Colors.black,
            items: _forums.map((forum) {
              return DropdownMenuItem(
                value: forum,
                child: Text(
                  forum,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedForum = value!;
              });
            },
          ),
        ],
      ),
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
          _reports.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              final report = filteredReports[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Report ID: ${report['id']}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        report['forum'],
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${report['reported_at']}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        report['description'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Reported by: ${report['username']}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (report['image_urls'] != null &&
                          report['image_urls'].isNotEmpty)
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: report['image_urls'].length,
                            itemBuilder: (context, imageIndex) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  report['image_urls'][imageIndex],
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _assignJob(int.parse(report['id'].toString())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text("Select as Job"),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
