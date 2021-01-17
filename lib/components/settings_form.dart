import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/localization/application.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:toast/toast.dart';

class SettingsForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  bool setting1 = false;
  bool setting2 = false;
  bool setting3 = false;

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        if (model.settingsLoading || model.settings == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SettingsList(
            sections: [
              SettingsSection(
                title: translator.text('settings_general'),
                tiles: [
                  SettingsTile(
                    title: translator.text('settings_general_language'),
                    subtitle: model.settings['locale'] == 'en'
                        ? 'English'
                        : 'العربية',
                    leading: setting1
                        ? CircularProgressIndicator()
                        : Icon(Icons.language),
                    onPressed: (BuildContext context) async {
                      setState(() => setting1 = true);
                      final locale =
                          model.settings['locale'] == 'en' ? 'ar' : 'en';
                      model.settings['locale'] = locale;
                      await model.setSettingsItem('locale', locale);
                      application.setLocale(locale);
                      final message = translator.text('settings_save_done');
                      Toast.show(message, this.context);
                      setState(() => setting1 = false);
                    },
                  ),
                  SettingsTile(
                    title: translator.text('settings_exchange_currency'),
                    subtitle:
                        model.settings['exchange'] == 'USD' ? 'USD' : 'IQD',
                    leading: setting2
                        ? CircularProgressIndicator()
                        : Icon(Icons.monetization_on),
                    onPressed: (BuildContext context) async {
                      setState(() => setting2 = true);
                      final exchange =
                          model.settings['exchange'] == 'USD' ? 'IQD' : 'USD';
                      model.settings['exchange'] = exchange;
                      await model.setSettingsItem('exchange', exchange);
                      await model.fetchProducts();
                      await model.fetchProvinces();
                      await model.restoreStoredOrder();
                      final message = translator.text('settings_save_done');
                      Toast.show(message, this.context);
                      setState(() => setting2 = false);
                    },
                  ),
                  SettingsTile.switchTile(
                      leading: setting3
                          ? CircularProgressIndicator()
                          : Icon(
                              Icons.notifications,
                            ),
                      title: translator.text('settings_notifications'),
                      onToggle: (bool value) async {
                        setState(() => setting3 = false);
                        model.settings['notifications'] = value;
                        await model.setSettingsItem('notifications', value);
                        final message = translator.text('settings_save_done');
                        Toast.show(message, this.context);
                        setState(() => setting3 = false);
                      },
                      switchValue: model.settings['notifications'] ?? true),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
