import 'package:crime_record_management_system/pages/people/model/people.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser {
  final ValueNotifier<People> currentPeople = ValueNotifier(emptyPeople());

  static People emptyPeople() {
    return People(0, '', '', '', '', '', 0, '', '', '');
  }

  Future<void> getPeopleInfo() async {
    try {
      People? getPeopleInfoFromLocalStorage = await PeoplePref.readPeople();
      currentPeople.value = getPeopleInfoFromLocalStorage ?? emptyPeople();
    } catch (e) {
      print("Error fetching people info: $e");
      currentPeople.value = emptyPeople();
    }
  }
}
