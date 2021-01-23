import 'urls.dart';

class Strings {
  static String applicationTitle = "Molar Dent";

  static Future<String> get downloadUrl async {
    final String android = Urls.PLAY_STORE_URL;
    final String ios = Urls.APP_STORE_URL;

    return '$android or $ios';
  }
}
