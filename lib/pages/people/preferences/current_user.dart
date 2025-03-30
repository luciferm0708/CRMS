import 'package:crime_record_management_system/pages/people/model/people.dart';
import 'package:crime_record_management_system/pages/people/preferences/people_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CurrentUser extends GetxController {
  RxString profileImageUrl = ''.obs; // Observable for profile image URL

  void updateProfileImageUrl(String url) {
    profileImageUrl.value = url;
  }
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
