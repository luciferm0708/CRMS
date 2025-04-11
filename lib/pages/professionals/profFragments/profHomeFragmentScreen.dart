import 'package:crime_record_management_system/pages/professionals/profPreferences/current_professionals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:particles_fly/particles_fly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfessionalHomeFragmentScreen extends StatefulWidget {
  final int professionalId;

  const ProfessionalHomeFragmentScreen({super.key, required this.professionalId});

  @override
  _ProfessionalHomeFragmentScreenState createState() => _ProfessionalHomeFragmentScreenState();
}

class _ProfessionalHomeFragmentScreenState extends State<ProfessionalHomeFragmentScreen> {
  List<dynamic> _reports = [];
  List<dynamic> _posts = [];
  String _selectedForum = "All";
  final _forums = ["All", "Mirpur", "Mohammadpur", "Savar"];
  final currentProfessional = CurrentProfessional();
  final Map<int, TextEditingController> _commentController = {};

  @override
  void initState() {
    super.initState();
    currentProfessional.getProfessionalInfo();
    _fetchReports();
    _loadSavedData();
  }

  Future<void> _fetchReports() async {
    try {
      final response = await http.get(Uri.parse(API.fetchReports));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print("Fetched API Response: ${jsonEncode(data)}");
        }
        if (data['status'] == 'success') {
          setState(() {
            _posts = (data['reports'] as List).map((p) {
              return {
                ...Map<String, dynamic>.from(p),
                'id': int.tryParse(p['id'].toString()) ?? 0,
                'prof_comments': (p['prof_comments'] is List)
                    ? List<Map<String, dynamic>>.from(
                    p['prof_comments'].map((c) => Map<String, dynamic>.from(c)))
                    : [],
                'prof_reactions': (p['reactions'] is Map)
                    ? Map<String, int>.from(p['reactions'])
                    : <String, int>{},
                'user_reaction': p['user_reaction'] ?? null,
              };
            }).toList();
          });
          await _savePostsLocally();
        } else {
          if (kDebugMode) {
            print("Failed to fetch posts: ${data['message']}");
          }
        }
      } else {
        if (kDebugMode) {
          print("Failed to load posts: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching posts: $e");
      }
    }
  }

  Future<void> _assignJob(int reportId) async {
    try {
      final response = await http.post(
        Uri.parse(API.assign_crime),
        body: {
          'report_id': reportId.toString(),
          'professional_id': currentProfessional.professionalId.toString(),
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          Fluttertoast.showToast(msg: "Job assigned successfully!");
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to assign job. Server error.");
      }
    } catch (e) {
      if (kDebugMode) print("Error assigning job: $e");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
  }

  Future<void> _loadSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedProfComments = preferences.getString("saved_ProfComments");
    String? savedProfReactions = preferences.getString("saved_ProfReactions");

    if (savedProfComments != null || savedProfReactions != null) {
      List<dynamic> profCommentsList =
      savedProfComments != null ? jsonDecode(savedProfComments) : [];
      List<dynamic> profReactsList =
      savedProfReactions != null ? jsonDecode(savedProfReactions) : [];
      setState(() {
        _posts = profCommentsList.map((post) {
          return {
            'id': post['id'],
            'prof_comments': post['prof_comments'] ?? [],
            'prof_reactions': {},
            'user_reaction': null
          };
        }).toList();
        for (var reactionPost in profReactsList) {
          var postIndex =
          _posts.indexWhere((post) => post['id'] == reactionPost['id']);
          if (postIndex != -1) {
            _posts[postIndex]['prof_reactions'] =
                reactionPost['prof_reactions'] ?? {};
            _posts[postIndex]['user_reaction'] = reactionPost['user_reaction'];
          }
        }
      });
    }
  }

  Future<void> _savePostsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_posts', jsonEncode(_posts));
  }

  Future<void> _loadSavedPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPosts = prefs.getString('saved_posts');
    if (savedPosts != null) {
      setState(() {
        _posts = List<Map<String, dynamic>>.from(jsonDecode(savedPosts));
      });
    }
  }

  Future<void> _fetchReactionsForPost(int postId, Map<String, dynamic> post) async {
    try {
      final response = await http.get(Uri.parse(
          "${API.fetchReactsProf}?id=$postId&professional_id=${currentProfessional.currentProfessional.value.professionalId}"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Map<String, dynamic> reactions = {};
          for (var reaction in data['prof_reactions']) {
            reactions[reaction['reaction_type']] = reaction['count'];
          }
          setState(() {
            post['prof_reactions'] = reactions;
            post['user_reaction'] = data['user_reaction'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching reactions for post $postId: $e");
      }
    }
  }

  Future<void> _reactToPost(dynamic postId, String reactionType) async {
    try {
      final reportId = postId is int ? postId : int.tryParse(postId.toString()) ?? 0;
      final professionalId = currentProfessional.currentProfessional.value.professionalId;
      if (professionalId == null || professionalId <= 0) {
        Fluttertoast.showToast(msg: "Invalid professional ID");
        return;
      }
      final postIndex = _posts.indexWhere((post) => post['id'] == postId);
      if (postIndex == -1) return;
      final post = _posts[postIndex];
      final existingReaction = post['user_reaction'];
      final isRemoving = existingReaction == reactionType;

      // Optimistic UI update
      setState(() {
        post['user_reaction'] = isRemoving ? null : reactionType;
        final reactions = Map<String, int>.from(post['prof_reactions'] ?? {});
        if (isRemoving) {
          reactions[reactionType] = (reactions[reactionType] ?? 1) - 1;
        } else {
          if (existingReaction != null) {
            reactions[existingReaction] = (reactions[existingReaction] ?? 1) - 1;
          }
          reactions[reactionType] = (reactions[reactionType] ?? 0) + 1;
        }
        post['prof_reactions'] = reactions;
      });

      final response = await http.post(
        Uri.parse(API.reactToPostProf),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'report_id': reportId,
          'reaction_type': isRemoving ? "remove" : reactionType,
          'professional_id': professionalId,
        }),
      );

      if (response.statusCode != 200) {
        setState(() {
          post['user_reaction'] = existingReaction;
        });
        throw Exception('Failed to update reaction');
      }

      await _fetchReactionsForPost(postId, post);
    } catch (e) {
      if (kDebugMode) {
        print("Error reacting: $e");
      }
      Fluttertoast.showToast(msg: "Failed to update reaction. Please try again.");
    }
  }

  Future<void> _addComment(int postId, String commentText) async {
    if (commentText.isEmpty) return;
    int postIndex = _posts.indexWhere((p) => p['id'] == postId);
    try {
      setState(() {
        if (_posts[postIndex]['prof_comments'] == null) {
          _posts[postIndex]['prof_comments'] = [];
        }
        _posts[postIndex]['prof_comments'].insert(0, {
          'username': currentProfessional.currentProfessional.value.username,
          'comment_text': commentText,
          'temporary': true
        });
      });
      await _savePostsLocally();

      final response = await http.post(
        Uri.parse(API.addProfComment),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'report_id': postId,
          'professional_id': currentProfessional.currentProfessional.value.professionalId,
          'comment_text': commentText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _posts[postIndex]['prof_comments'].removeWhere((c) => c['temporary'] == true);
          });
          await _fetchSinglePostComments(postId);
          await _savePostsLocally();
        }
      } else {
        if (kDebugMode) {
          print("Failed to add comment: ${response.body}");
        }
        _fetchReports();
      }
      _commentController[postId]?.clear();
    } catch (e) {
      setState(() {
        _posts[postIndex]['prof_comments'].removeWhere((c) => c['temporary'] == true);
      });
      Fluttertoast.showToast(msg: "Failed to post comment");
    }
  }

  Future<void> _fetchSinglePostComments(int postId) async {
    try {
      final response = await http.get(Uri.parse('${API.fetchProfComment}?id=$postId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            final postIndex = _posts.indexWhere((p) => p['id'] == postId);
            if (postIndex != -1) {
              // Replace the entire comments list with the fetched comments
              _posts[postIndex]['prof_comments'] = data['comments'];
            }
          });
          await _savePostsLocally();
        }
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching comments: $e");
    }
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Information
            _buildReportInfo(post),
            const SizedBox(height: 10),
            // Images of the Post
            if (post['image_urls'] != null && post['image_urls'].isNotEmpty)
              _buildPostImages(post),
            // Reactions Section
            _buildReactions(post),
            const SizedBox(height: 8),
            // Comments Section
            _buildComments(post),
            const SizedBox(height: 12),
            // Select as Job button
            Center(
              child: ElevatedButton(
                onPressed: () => _assignJob(post['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Select as Job",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportInfo(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Report ID: ${post['id']}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(post['description'], style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        Text("${post['reported_at']}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Text("Reported by: ${post['username']}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildPostImages(Map<String, dynamic> post) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post['image_urls'].length,
        itemBuilder: (context, imageIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post['image_urls'][imageIndex],
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReactions(Map<String, dynamic> post) {
    return Row(
      children: [
        _reactionButton(post, "upvote", Icons.thumb_up, Colors.blue),
        Text("${post['prof_reactions']?['upvote'] ?? 0}", style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        _reactionButton(post, "downvote", Icons.thumb_down, Colors.red),
        Text("${post['prof_reactions']?['downvote'] ?? 0}", style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _reactionButton(Map<String, dynamic> post, String reactionType, IconData icon, Color color) {
    return IconButton(
      icon: Icon(
        post['user_reaction'] == reactionType ? icon : icon,
        color: post['user_reaction'] == reactionType ? color : Colors.white,
      ),
      onPressed: () => _reactToPost(post['id'], reactionType),
      splashColor: color.withOpacity(0.3),
    );
  }

  Widget _buildComments(Map<String, dynamic> post) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: post['prof_comments']?.length ?? 0,
          itemBuilder: (context, index) {
            final comment = post['prof_comments'][index];
            return _buildCommentCard(comment);
          },
        ),
        _buildCommentInput(post),
      ],
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Card(
      color: comment['temporary'] == true ? Colors.grey[700] : Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(comment['username'][0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          comment['username'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment['comment_text'],
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            if (comment['temporary'] == true)
              Text(
                "Posting...",
                style: TextStyle(color: Colors.grey[400], fontSize: 10, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput(Map<String, dynamic> post) {
    final int reportId = int.tryParse(post['id'].toString()) ?? 0;
    return TextField(
      controller: _commentController[reportId] ??= TextEditingController(),
      decoration: InputDecoration(
        hintText: "Add a comment...",
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onSubmitted: (value) {
        _addComment(reportId, value);
        _commentController[reportId]?.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<dynamic> filteredReports = _selectedForum == "All"
        ? _posts
        : _posts.where((report) => report['forum'] == _selectedForum).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Professional Dashboard"),
        backgroundColor: Colors.black,
        actions: [
          DropdownButton<String>(
            value: _selectedForum,
            dropdownColor: Colors.black,
            items: _forums.map((forum) {
              return DropdownMenuItem(
                value: forum,
                child: Text(forum, style: const TextStyle(color: Colors.white)),
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
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              final report = filteredReports[index];
              return _buildPostCard(report);
            },
          ),
        ],
      ),
    );
  }
}