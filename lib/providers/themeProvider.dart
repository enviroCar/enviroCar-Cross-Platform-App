import 'package:flutter/material.dart';

import '../globals.dart';
import '../constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _appTheme =
  preferences.get('theme') == 'light' ? lightThemeData : darkThemeData;

  ThemeData get getTheme {
    return _appTheme;
  }

  void switchThemeData() {
    if (_appTheme == lightThemeData) {
      _appTheme = darkThemeData;
    } else {
      _appTheme = lightThemeData;
    }

    notifyListeners();
  }
}

ThemeData darkThemeData = ThemeData(
  accentColor: kSpringColor,
  primaryColor: Colors.black,
  dialogBackgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  dividerColor: Colors.white,
  hintColor: Colors.white,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  dialogTheme: const DialogTheme(
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  canvasColor: Colors.black,
  unselectedWidgetColor: Colors.white,
  textTheme: TextTheme(
    bodyText1: const TextStyle(
      color: Colors.white,
    ),
    bodyText2: const TextStyle(
      color: Colors.white,
    ),
    button: const TextStyle(
      color: Colors.white,
    ),
    caption: const TextStyle(
      color: Colors.white,
    ),
    subtitle1: const TextStyle(
      color: Colors.white,
    ),
    subtitle2: const TextStyle(
      color: Colors.white,
    ),
    headline1: TextStyle(
        color: kGreyColor.withOpacity(0.5)
    ),
  ),
);

ThemeData lightThemeData = ThemeData(
  primaryColor: Colors.white,
  appBarTheme: AppBarTheme(
    actionsIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    color: Colors.red,
    titleTextStyle: const TextStyle(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: kGreyColor.withOpacity(0.5)
      ),
      headline1: TextStyle(
          color: kGreyColor.withOpacity(0.5)
      ),
    ),
  ),
);
