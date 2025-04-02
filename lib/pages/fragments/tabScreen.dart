import 'package:crime_record_management_system/pages/people/preferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../people/model/people.dart';


class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final CurrentUser _currentPeople = Get.put(CurrentUser());
  int _selectDrawerIndex = 0;

  @override
  void initState () {
    super.initState();
    _currentPeople.getPeopleInfo();
  }

  final List<Widget> _drawerScreens = [
    Center(
      child: Text(
        "Home",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Center(
      child: Text(
        "Privacy & Policy",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Center(
      child: Text(
        "Settings",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Center(
      child: Text(
        "Help & Support",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Center(
      child: Text(
        "About",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];

  _onSelectItem(int index) {
    setState(() {
      _selectDrawerIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tab"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ValueListenableBuilder<People>
              (
                valueListenable: _currentPeople.currentPeople,
                builder: (context, people, child) {
                  return DrawerHeader(
                    decoration: BoxDecoration(color:  Colors.red),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        people.username.isEmpty
                            ? "Welcome, User"
                            : "Welcome, ${people.username}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
              ),
              selected: _selectDrawerIndex == 0,
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text(
                "Privacy & Policy",
              ),
              selected: _selectDrawerIndex == 1,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
              ),
              selected: _selectDrawerIndex == 2,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text(
                "Help & Support",
              ),
              selected: _selectDrawerIndex == 3,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(
                "About Us",
              ),
              selected: _selectDrawerIndex == 4,
              onTap: () => _onSelectItem(1),
            ),
          ],
        ),
      ),
      body: _drawerScreens[_selectDrawerIndex],
    );
  }
}

