import 'package:flutter/material.dart';
import '../people/authentication/logIn.dart';
import '../people/preferences/current_user.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CurrentUser currentUser = CurrentUser();
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await currentUser.getPeopleInfo();
    setState(() => _isLoading = false);
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            color: Colors.grey[800],
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                currentUser.currentPeople.value.username ?? 'Username',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                currentUser.currentPeople.value.email ?? 'email@example.com',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Account Settings
          _buildSectionHeader('Account Settings'),
          _buildSettingsCard(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
              activeColor: Colors.purpleAccent,
            ),
          ),
          _buildSettingsCard(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) => setState(() => _darkModeEnabled = value),
              activeColor: Colors.purpleAccent,
            ),
          ),

          // Support Section
          _buildSectionHeader('Support'),
          _buildSettingsCard(
            icon: Icons.help,
            title: 'Help Center',
            onTap: () {/* Add navigation */},
          ),
          _buildSettingsCard(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {/* Add navigation */},
          ),

          // Logout Section
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Log Out', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _showLogoutConfirmation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.grey[800],
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}