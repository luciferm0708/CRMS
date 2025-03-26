import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class AdminPreferencesPage extends StatefulWidget {
  @override
  _AdminPreferencesPageState createState() => _AdminPreferencesPageState();
}

class _AdminPreferencesPageState extends State<AdminPreferencesPage> {
  bool _notificationsEnabled = false;
  String _defaultLanguage = 'English';
  final _apiEndpointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _defaultLanguage = prefs.getString('defaultLanguage') ?? 'English';
      _apiEndpointController.text = prefs.getString('apiEndpoint') ?? '';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('defaultLanguage', _defaultLanguage);
    await prefs.setString('apiEndpoint', _apiEndpointController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Default Language'),
              value: _defaultLanguage,
              items: <String>['English', 'Spanish', 'French', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _defaultLanguage = newValue!;
                });
              },
            ),
            TextFormField(
              controller: _apiEndpointController,
              decoration: InputDecoration(labelText: 'API Endpoint'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePreferences,
              child: Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}