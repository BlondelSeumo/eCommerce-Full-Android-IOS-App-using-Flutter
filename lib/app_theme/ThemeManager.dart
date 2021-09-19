import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/app_theme/StorageManager.dart';
import 'package:nyoba/utils/utility.dart';

class ThemeNotifier with ChangeNotifier {

  bool isDarkMode = false;

  final lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    accentTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Poppins',
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
    ),
    accentTextTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
    ),
  );

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        isDarkMode = false;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        isDarkMode = true;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
