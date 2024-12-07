import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:particles_fly/particles_fly.dart';

import '../../api/api.dart';

class HomeFragmentScreen extends StatefulWidget {
  @override
  _HomeFragmentScreenState createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  List<dynamic> _posts = [];
  String _selectedForum = "All";
  final _forums = ["All", "Mirpur", "Mohammadpur", "Savar"];

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts when the screen is loaded
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(API.fetchReports));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _posts = data['reports']; // Update _posts with fetched data
          });
        } else {
          print("Failed to fetch posts: ${data['message']}");
        }
      } else {
        print("Failed to load posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Filter posts by forum
    List<dynamic> filteredPosts = _selectedForum == "All"
        ? _posts
        : _posts.where((post) => post['forum'] == _selectedForum).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Home"),
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
          _posts.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
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
                        post['forum'],
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        post['description'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (post['image_urls'] != null &&
                          post['image_urls'].isNotEmpty)
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: post['image_urls'].length,
                            itemBuilder: (context, imageIndex) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  post['image_urls'][imageIndex],
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
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
