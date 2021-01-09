import 'package:android_play_install_referrer/android_play_install_referrer.dart';

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
}
