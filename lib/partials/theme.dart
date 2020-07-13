import 'package:flutter/material.dart';

ThemeData getThemeData() {
  const Color darkThemePrimaryColor = Color(0xff212121);
  const Color darkThemePrimaryColorDark = Color(0xff2B2B2B);
  const Color darkThemeAccentColor = Colors.blue;

  return ThemeData(
    primaryColor: darkThemePrimaryColor,
    primaryColorDark: darkThemePrimaryColorDark,
    accentColor: darkThemeAccentColor,
    canvasColor: Colors.transparent,
    primaryIconTheme: IconThemeData(color: Colors.white),
//    backgroundColor: Colors.white,
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      headline3: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
      headline4: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 26),
      headline5: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
      bodyText2: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
      bodyText1: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
      caption: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkThemePrimaryColorDark),
    fontFamily: 'Sans',
  );
}
