import 'dart:convert';

import 'package:drugStore/localization/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SettingsStatus { Null, Loading, Ready }

class Settings {
  Map<String, dynamic> _data;
  SettingsStatus _status;

  final void Function() notifier;

  Settings(this.notifier)
      : this._status = SettingsStatus.Null,
        this._data = {'locale': 'ar', 'notifications': true};

  Map<String, dynamic> get data => Map.from(this._data);

  SettingsStatus get status => this._status;

  Future<void> load() async {
    assert(notifier != null);

    _status = SettingsStatus.Loading;
    notifier();

    final prefs = await SharedPreferences.getInstance();
    final String content = prefs.getString('_settings');

    if (content != null) {
      _data = json.decode(content);
    }

    _status = SettingsStatus.Ready;
    notifier();
  }

  Future<void> store(
      Map<String, dynamic> data, void Function() notifier) async {
    assert(notifier != null);

    _status = SettingsStatus.Loading;
    notifier();

    final String value = json.encode(data);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('_settings', value);
      notifier();
    });
  }

  Future<void> alternateLanguage(void Function() notifier) async {
    final String current = this.data['locale'];
    final String alternate = current == 'en' ? 'ar' : 'en';

    this.data['locale'] = alternate;
    this
        .store(data, notifier)
        .then((value) => application.setLocale(alternate));
  }
}
