import 'package:drugStore/constants/envirnoment.dart';
import 'package:drugStore/constants/urls.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

const APP_STORE_URL = Urls.APP_STORE_URL;
const PLAY_STORE_URL = Urls.PLAY_STORE_URL;

class VersionChecker {
  static Future<String> checkVersion(BuildContext context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double current = double.parse(info.version.trim().replaceAll(".", ""));

    try {
      final response = await Http.get(Environment.latestVersionUrl, {});

      if (response == null || response.error != null) {
        throw new Exception('Connection error');
      }
      final info = response.result;

      double latest = double.parse(info['version'].trim().replaceAll(".", ""));
      if (latest > current) {
        _openDialog(context, info['message']);
      }
      return info.version;
    } catch (exception) {
      print('Unable to fetch new version details');
      return 'UNKNOWN';
    }
  }

  static Future<void> _openDialog(BuildContext context, String message) async {
    final translator = AppTranslations.of(context);

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final String title = translator.text('new_version_available');
        final String btn1 = translator.text('buttons.update');
        final String btn2 = translator.text('buttons.later');

        final theme = Theme.of(context);

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            OutlineButton(
              child: Text(btn1),
              onPressed: () => _launchURL(PLAY_STORE_URL),
              textColor: theme.accentColor,
            ),
            OutlineButton(
              child: Text(btn2),
              onPressed: () => Navigator.pop(context),
              textColor: theme.accentColor,
            ),
          ],
        );
      },
    );
  }

  static Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
