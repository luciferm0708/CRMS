import 'dart:convert';

import '../model/people.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeoplePref
{
  static const String _profileImageUrlKey = 'profileImageUrl';

  static Future<void> saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageUrlKey, url);
  }

  static Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageUrlKey);
  }
  static Future<void> storePeopleInfo(People peopleInfo) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String peopleJsonData = jsonEncode(peopleInfo.toJson());
    await preferences.setString("currentPeople", peopleJsonData);
  }

  static Future<People?> readPeople() async
  {
    People? currentPeopleInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? peopleInfo = preferences.getString("currentPeople");
    if(peopleInfo != null)
    {
      Map<String, dynamic> peopleDataMap = jsonDecode(peopleInfo);
      return People.fromJson(peopleDataMap);
    }
    return currentPeopleInfo;
  }

  static Future<void> removePeopleInfo() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentPeople");
  }
}