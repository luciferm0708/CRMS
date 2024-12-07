import 'package:flutter/material.dart';
import 'package:crime_record_management_system/themes/dark_mode.dart';
import 'package:crime_record_management_system/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier{

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }
  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
  }
    else{
      themeData = lightMode;
  }
}
}