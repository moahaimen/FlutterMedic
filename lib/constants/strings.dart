import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:flutter/material.dart';

class Strings {
  static String applicationTitle = "Molar Dent";
  static Future<String> get downloadUrl async {
    String referrerDetailsString;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.toString();
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }
    return referrerDetailsString;
  }

  static String currency(BuildContext context) {
    final translator = AppTranslations.of(context);
    final currency = translator.text('currency');

    return currency;
  }
}
