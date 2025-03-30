import 'dart:convert';
import '../model/professional.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionalPref {
  static Future<void> storeProfessionalInfo(Professional professionalInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String professionalJsonData = jsonEncode(professionalInfo.toJson());
    await preferences.setString("currentProfessional", professionalJsonData);
  }

  static Future<Professional?> readProfessional() async {
    Professional? currentProfessionalInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? professionalInfo = preferences.getString("currentProfessional");
    if (professionalInfo != null) {
      Map<String, dynamic> professionalDataMap = jsonDecode(professionalInfo);
      return Professional.fromJson(professionalDataMap);
    }
    return currentProfessionalInfo;
  }

  static Future<void> removeProfessionalInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentProfessional");
  }
}
