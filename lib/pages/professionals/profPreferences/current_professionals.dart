import 'package:crime_record_management_system/pages/professionals/profPreferences/professional_preference.dart';
import 'package:flutter/cupertino.dart';
import '../model/professional.dart';
class CurrentProfessional {
  final ValueNotifier<Professional> currentProfessional = ValueNotifier(emptyProfessional());

  static Professional emptyProfessional() {
    return Professional(0, '', '', '', '', '', '', '', '', '', '', '', '', '');
  }

  int get professionalId => currentProfessional.value.professionalId;

  Future<void> getProfessionalInfo() async {
    try {
      Professional? getProfessionalInfoFromLocalStorage = await ProfessionalPref.readProfessional();
      currentProfessional.value = getProfessionalInfoFromLocalStorage ?? emptyProfessional();
    } catch (e) {
      print("Error fetching professional info: $e");
      currentProfessional.value = emptyProfessional();
    }
  }
}


