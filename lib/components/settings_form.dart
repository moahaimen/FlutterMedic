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
          print(model.settings);
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
                    leading: Icon(Icons.language),
                    onTap: () {
                      setState(() async {
                        final locale =
                            model.settings['locale'] == 'en' ? 'ar' : 'en';
                        model.settings['locale'] = locale;
                        await model.setSettingsItem('locale', locale);
                        application.setLocale(locale);
                        final message = translator.text('settings_save_done');
                        Toast.show(message, this.context);
                      });
                    },
                  ),
                  SettingsTile(
                    title: translator.text('settings_exchange_currency'),
                    subtitle:
                        model.settings['exchange'] == 'USD' ? 'USD' : 'IQD',
                    leading: Icon(Icons.monetization_on),
                    onTap: () {
                      setState(() async {
                        final exchange =
                            model.settings['exchange'] == 'USD' ? 'IQD' : 'USD';
                        model.settings['exchange'] = exchange;
                        await model.setSettingsItem('exchange', exchange);
                        model.fetchProducts();
                        final message = translator.text('settings_save_done');
                        Toast.show(message, this.context);
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                      leading: Icon(Icons.notifications),
                      title: translator.text('settings_notifications'),
                      onToggle: (bool value) {
                        setState(() async {
                          model.settings['notifications'] = value;
                          await model.setSettingsItem('notifications', value);
                          final message = translator.text('settings_save_done');
                          Toast.show(message, this.context);
                        });
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
