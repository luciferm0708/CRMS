<<<<<<< HEAD
=======
import 'package:flutter/foundation.dart';
>>>>>>> 22ffd23 (bug fixed and UI update)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:particles_fly/particles_fly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../people/preferences/current_user.dart';


class HomeFragmentScreen extends StatefulWidget {
<<<<<<< HEAD
=======
  const HomeFragmentScreen({super.key});

>>>>>>> 22ffd23 (bug fixed and UI update)
  @override
  _HomeFragmentScreenState createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  List<dynamic> _posts = [];
  String _selectedForum = "All";
  final _forums = ["All", "Mirpur", "Mohammadpur", "Savar"];
  final Map<int, TextEditingController> _commentController = {};
  final currentUser = CurrentUser();

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    //_loadSavedData();
=======
    _loadSavedData();
>>>>>>> 22ffd23 (bug fixed and UI update)
    _fetchPosts();
    _loadSavedPosts();
    currentUser.getPeopleInfo();
  }

  /*Future<void> _saveCommentsLocally() async{
    SharedPreferences commentPrefs = await SharedPreferences.getInstance();
    String jsonComments = jsonEncode(_posts.map((post){
      return{
        'id': post['id'],
        'comments': post['comments'],
      };
    }).toList());
    await commentPrefs.setString('saved_comments', jsonComments);
<<<<<<< HEAD
  }

  Future<void> _saveReactionsLocally() async{
=======
  }*/

  /*Future<void> _saveReactionsLocally() async{
>>>>>>> 22ffd23 (bug fixed and UI update)
    SharedPreferences reactionPrefs = await SharedPreferences.getInstance();
    String jsonReacts = jsonEncode(_posts.map((post){
      return{
        'id':post['id'],
        'reactions': post['reactions'],
        'user_reaction': post['user_reaction'],
      };
    }).toList());

    await reactionPrefs.setString('saved_reacts', jsonReacts);
<<<<<<< HEAD
  }
=======
  }*/
>>>>>>> 22ffd23 (bug fixed and UI update)

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedComments = prefs.getString('saved_comments');
    String? savedReactions = prefs.getString('saved_reacts');

    if (savedComments != null || savedReactions != null) {
      List<dynamic> commentsList = savedComments != null ? jsonDecode(savedComments) : [];
      List<dynamic> reactionsList = savedReactions != null ? jsonDecode(savedReactions) : [];

      setState(() {
        _posts = commentsList.map((post) {
          return {
            'id': post['id'],
            'comments': post['comments'] ?? [],
            'reactions': {},
            'user_reaction': null
          };
        }).toList();

        for (var reactionPost in reactionsList) {
          var postIndex = _posts.indexWhere((post) => post['id'] == reactionPost['id']);
          if (postIndex != -1) {
            _posts[postIndex]['reactions'] = reactionPost['reactions'] ?? {};
            _posts[postIndex]['user_reaction'] = reactionPost['user_reaction'];
          }
        }
      });
    }
<<<<<<< HEAD
  }*/

  /*Future<void> _fetchPosts() async {
=======
  }

  Future<void> _fetchPosts() async {
>>>>>>> 22ffd23 (bug fixed and UI update)
    try {
      final response = await http.get(Uri.parse(API.fetchReports));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

<<<<<<< HEAD
        print("Fetched API Response: ${jsonEncode(data)}");
=======
        if (kDebugMode) {
          print("Fetched API Response: ${jsonEncode(data)}");
        }
>>>>>>> 22ffd23 (bug fixed and UI update)

        if (data['status'] == 'success') {
          setState(() {
            List<dynamic> apiPosts = (data['reports'] as List).map((p) {
              return {
                ...Map<String, dynamic>.from(p),
                'id': int.tryParse(p['id'].toString()) ?? 0,
                'comments': (p['comments'] is List)
                    ? List<Map<String, dynamic>>.from(p['comments'].map((c) => Map<String, dynamic>.from(c)))
                    : [],
              };
            }).toList();
            for (var savedPost in _posts) {
              var postIndex = apiPosts.indexWhere((post) => post['id'] == savedPost['id']);
              if (postIndex != -1) {
                apiPosts[postIndex]['comments'] = savedPost['comments'];
                apiPosts[postIndex]['reactions'] = savedPost['reactions'] ?? {};
                apiPosts[postIndex]['user_reaction'] = savedPost['user_reaction'];
              }
            }

            _posts = apiPosts;
          });
        } else {
<<<<<<< HEAD
          print("Failed to fetch posts: ${data['message']}");
        }
      } else {
        print("Failed to load posts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }*/
=======
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
>>>>>>> 22ffd23 (bug fixed and UI update)
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

<<<<<<< HEAD
  Future<void> _fetchPosts() async {
=======
  /*Future<void> _fetchPosts() async {
>>>>>>> 22ffd23 (bug fixed and UI update)
    try {
      final response = await http.get(Uri.parse(API.fetchReports));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          List<dynamic> newPosts = (data['reports'] as List).map((p) {
            return {
              ...Map<String, dynamic>.from(p),
              'id': int.tryParse(p['id'].toString()) ?? 0,
              'comments': (p['comments'] is List)
                  ? List<Map<String, dynamic>>.from(
                  (p['comments'] as List).map((c) => Map<String, dynamic>.from(c as Map)))
                  : [],
              'reactions': {}, // Empty for now, will fetch separately
              'user_reaction': null, // Will fetch from API
            };
          }).toList();

          for (var post in newPosts) {
            await _fetchReactionsForPost(post['id'], post);
          }

          setState(() {
            _posts = newPosts;
            _savePostsLocally(); // Save posts with user reactions
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
<<<<<<< HEAD
  }

// ✅ Fetch reactions from fetchreacts.php for a single post
=======
  }*/

>>>>>>> 22ffd23 (bug fixed and UI update)
  Future<void> _fetchReactionsForPost(int postId, Map<String, dynamic> post) async {
    try {
      final response = await http.get(Uri.parse("${API.fetchReacts}?id=$postId&people_id=${currentUser.currentPeople.value.people_id}"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Map<String, dynamic> reactions = {};
          for (var reaction in data['reactions']) {
            reactions[reaction['reaction_type']] = reaction['count'];
          }

          setState(() {
            post['reactions'] = reactions;
<<<<<<< HEAD
            post['user_reaction'] = data['user_reaction']; // ✅ Get user's reaction
=======
            post['user_reaction'] = data['user_reaction'];
>>>>>>> 22ffd23 (bug fixed and UI update)
          });
        }
      }
    } catch (e) {
<<<<<<< HEAD
      print("Error fetching reactions for post $postId: $e");
=======
      if (kDebugMode) {
        print("Error fetching reactions for post $postId: $e");
      }
>>>>>>> 22ffd23 (bug fixed and UI update)
    }
  }


  Future<void> _reactToPost(dynamic postId, String reactionType) async {
    try {
      int reportId = int.tryParse(postId.toString()) ?? 0;
      String peopleID = currentUser.currentPeople.value.people_id.toString();

      int postIndex = _posts.indexWhere((post) => post['id'].toString() == postId.toString());
      if (postIndex == -1) return;

      var post = _posts[postIndex];

      if (post['reactions'] is! Map<String, dynamic>) {
        post['reactions'] = Map<String, dynamic>.from(post['reactions'] ?? {});
      }

      String? existingReaction = post['user_reaction'];
      bool isRemoving = (existingReaction == reactionType);
<<<<<<< HEAD
      bool isSwitching = (existingReaction != null && existingReaction != reactionType);
=======
>>>>>>> 22ffd23 (bug fixed and UI update)

      setState(() {
        if (isRemoving) {
          post['user_reaction'] = null;
        } else {
          post['user_reaction'] = reactionType;
        }
      });

      _savePostsLocally();

      final response = await http.post(
        Uri.parse(API.reactToPost),
        body: {
          'report_id': reportId.toString(),
          'reaction_type': isRemoving ? "remove" : reactionType,
          'people_id': peopleID,
        },
      );

      if (response.statusCode != 200) {
<<<<<<< HEAD
        print("Failed to react: ${response.body}");
=======
        if (kDebugMode) {
          print("Failed to react: ${response.body}");
        }
>>>>>>> 22ffd23 (bug fixed and UI update)
        _fetchPosts();
      } else {
        // Fetch updated reactions from server
        await _fetchReactionsForPost(postId, post);
      }
    } catch (e) {
<<<<<<< HEAD
      print("Error reacting: $e");
=======
      if (kDebugMode) {
        print("Error reacting: $e");
      }
>>>>>>> 22ffd23 (bug fixed and UI update)
    }
  }

  Future<void> _addComment(int postId, String commentText) async {
    if (commentText.isEmpty) return;

    try {
      String peopleID = currentUser.currentPeople.value.people_id.toString();

      int postIndex = _posts.indexWhere((p) => p['id'] == postId);
      if (postIndex != -1) {
        setState(() {
          _posts[postIndex]['comments'].add({
            'username': currentUser.currentPeople.value.username,
            'comment_text': commentText,
          });
        });
      }

      _savePostsLocally();

      final response = await http.post(
        Uri.parse(API.addComment),
        body: {
          'report_id': postId.toString(),
          'people_id': peopleID,
          'comment_text': commentText
        },
      );

      if (response.statusCode != 200) {
<<<<<<< HEAD
        print("Failed to add comment: ${response.body}");
=======
        if (kDebugMode) {
          print("Failed to add comment: ${response.body}");
        }
>>>>>>> 22ffd23 (bug fixed and UI update)
        _fetchPosts();
      } else {
        Future.delayed(Duration(milliseconds: 500), _fetchPosts);
      }

      _commentController[postId]?.clear();
    } catch (e) {
<<<<<<< HEAD
      print("Error commenting: $e");
=======
      if (kDebugMode) {
        print("Error commenting: $e");
      }
>>>>>>> 22ffd23 (bug fixed and UI update)
    }
  }

  Widget _buildPostCard(Map<String, dynamic> post) {

<<<<<<< HEAD
    final int reportId = int.tryParse(post['id'].toString()) ?? 0;
=======
>>>>>>> 22ffd23 (bug fixed and UI update)
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(10),
      ),
=======
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
>>>>>>> 22ffd23 (bug fixed and UI update)
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text(
              "Report ID: ${post['id']}",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              post['description'],
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "${post['reported_at']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
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
            // Display the username of the person who posted the report
            Text(
              "Reported by: ${post['username']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
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
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post['user_reaction'] == "upvote" ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: post['user_reaction'] == "upvote" ? Colors.blue : Colors.white,
                  ),
                  onPressed: () => _reactToPost(post['id'], "upvote"),
                ),
                Text("${post['reactions']?['upvote'] ?? 0}",
                    style: TextStyle(color: Colors.white)),

                IconButton(
                  icon: Icon(
                    post['user_reaction'] == "downvote" ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                    color: post['user_reaction'] == "downvote" ? Colors.red : Colors.white,
                  ),
                  onPressed: () => _reactToPost(post['id'], "downvote"),
                ),
                Text("${post['reactions']?['downvote'] ?? 0}",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: post['comments']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final comment = post['comments'][index];
                    return ListTile(
                      title: Text(comment['username'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(comment['comment_text'],
                          style: TextStyle(color: Colors.white70)),
                    );
                  },
                ),
                TextField(
                  controller: _commentController[reportId] ??= TextEditingController(),
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    _addComment(reportId, value);
                    _commentController[reportId]?.clear();
                  },
                ),
              ],
            ),
=======
            // Report Information
            _buildReportInfo(post),

            SizedBox(height: 10),

            // Images of the Post
            if (post['image_urls'] != null && post['image_urls'].isNotEmpty)
              _buildPostImages(post),

            // Reactions Section
            _buildReactions(post),

            SizedBox(height: 8),

            // Comments Section
            _buildComments(post),
>>>>>>> 22ffd23 (bug fixed and UI update)
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
=======
  Widget _buildReportInfo(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Report ID: ${post['id']}", style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text(post['description'], style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 8),
        Text("${post['reported_at']}", style: TextStyle(color: Colors.white70, fontSize: 14)),
        SizedBox(height: 8),
        Text("Reported by: ${post['username']}", style: TextStyle(color: Colors.white70, fontSize: 14)),
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
        Text("${post['reactions']?['upvote'] ?? 0}", style: TextStyle(color: Colors.white)),

        _reactionButton(post, "downvote", Icons.thumb_down, Colors.red),
        Text("${post['reactions']?['downvote'] ?? 0}", style: TextStyle(color: Colors.white)),
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
      splashColor: color.withOpacity(0.3), // Adds a subtle splash effect
    );
  }

  Widget _buildComments(Map<String, dynamic> post) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: post['comments']?.length ?? 0,
          itemBuilder: (context, index) {
            final comment = post['comments'][index];
            return _buildCommentCard(comment);
          },
        ),
        _buildCommentInput(post),
      ],
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(comment['username'][0].toUpperCase(), style: TextStyle(color: Colors.white)),
        ),
        title: Text(
          comment['username'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          comment['comment_text'],
          style: TextStyle(color: Colors.white70, fontSize: 12),
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
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      onSubmitted: (value) {
        _addComment(reportId, value);
        _commentController[reportId]?.clear();
      },
    );
  }


>>>>>>> 22ffd23 (bug fixed and UI update)
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(filteredPosts[index]);
            },
          ),
        ],
      ),
    );
  }
}