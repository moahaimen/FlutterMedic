import 'package:drugStore/constants/colors.dart';
import 'package:flutter/material.dart';

class ThemeBuilder {
  static ThemeData getTheme() {
    const Color primaryColor = AppColors.primaryColor;
    const Color primaryColorDark = AppColors.primaryColorDark;
    const Color accentColor = AppColors.accentColor;

    const Color secondaryColor = AppColors.secondaryColor;
    const Color primaryTextColor = AppColors.primaryTextColor;

    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      colorScheme: ColorScheme.light()
          .copyWith(primary: primaryColor, primaryVariant: primaryColorDark),
      accentColor: accentColor,
      canvasColor: secondaryColor,
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(headline3: TextStyle(color: accentColor))),
      iconTheme: IconThemeData(size: 22, color: accentColor),
      primaryIconTheme: IconThemeData(color: accentColor),
      backgroundColor: Colors.white,
      primaryColorLight: accentColor,
      cardTheme: CardTheme(
        color: Colors.white,
      ),
      buttonColor: accentColor,
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: accentColor),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        disabledColor: primaryColor.withAlpha(100),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.w800,
          color: primaryTextColor,
          fontSize: 28,
        ),
        headline2: TextStyle(
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          fontSize: 25.5,
        ),
        headline3: TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
          fontSize: 23,
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
          fontSize: 20,
        ),
        headline5: TextStyle(
          fontWeight: FontWeight.w400,
          color: primaryTextColor,
          fontSize: 18,
        ),
        bodyText1: TextStyle(
          fontWeight: FontWeight.w200,
          color: primaryTextColor,
          fontSize: 16,
        ),
        bodyText2: TextStyle(
          fontWeight: FontWeight.normal,
          color: primaryTextColor,
          fontSize: 13,
        ),
        caption: TextStyle(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          color: primaryTextColor,
          fontSize: 11,
        ),
        button: TextStyle(
          color: primaryColor,
        ),

      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: primaryTextColor,
      ),
      fontFamily: 'Changa',
    );
  }
}
