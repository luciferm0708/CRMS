import 'package:crime_record_management_system/pages/fragments/home.dart';
import 'package:crime_record_management_system/pages/get_started.dart';
import 'package:crime_record_management_system/pages/logInInterface.dart';
import 'package:crime_record_management_system/pages/people/authentication/logIn.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crime Report Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: PeoplePref.readPeople(),
          builder: (context, dataSnapShot)
          {
            if(dataSnapShot.data == null)
              {
                return Logininterface();
              }
            else
              {
                return Home();
              }
          }
      )
    );
  }
}
