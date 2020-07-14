import 'package:flutter/material.dart';

ThemeData getThemeData() {
  const Color darkThemePrimaryColor = Color(0xff212121);
  const Color darkThemePrimaryColorDark = Color(0xff2B2B2B);
  const Color darkThemeAccentColor = Colors.lightGreen;

  return ThemeData(
    primaryColor: darkThemePrimaryColor,
    primaryColorDark: darkThemePrimaryColorDark,
    accentColor: darkThemeAccentColor,
    canvasColor: Colors.transparent,
    iconTheme: IconThemeData(size: 28, color: darkThemeAccentColor),
    primaryIconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Colors.white,
    primaryColorLight: darkThemeAccentColor,
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: darkThemeAccentColor,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 21),
      headline2: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
      headline3: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17),
      headline4: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
      headline5: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
      bodyText1: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
      bodyText2: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
      caption: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: Colors.white,
          fontSize: 11),
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkThemeAccentColor,
          fontSize: 34),
      headline2: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkThemeAccentColor,
          fontSize: 31),
      headline3: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkThemeAccentColor,
          fontSize: 29),
      headline4: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkThemeAccentColor,
          fontSize: 26),
      headline5: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkThemeAccentColor,
          fontSize: 23),
      bodyText1: TextStyle(
          fontWeight: FontWeight.normal,
          color: darkThemeAccentColor,
          fontSize: 20),
      bodyText2: TextStyle(
          fontWeight: FontWeight.normal,
          color: darkThemeAccentColor,
          fontSize: 16),
      caption: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: darkThemeAccentColor,
          fontSize: 11),
    ),
    fontFamily: 'Sans',
  );
}
