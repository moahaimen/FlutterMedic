import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/localization/application.dart';
import 'package:drugStore/models/settings.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/router.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:toast/toast.dart';

typedef Future<void> SaveSettingsMethod(Map<String, dynamic> settings);

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder.build(context, Router.settings),
      appBar: Toolbar.get(title: Router.settings, context: context),
      body: ScopedModelDescendant<StateModel>(
        builder: (BuildContext context, Widget child, StateModel model) =>
            _buildSettingsBody(model.settings),
      ),
    );
  }

  Widget _buildSettingsBody(Settings settings) {
    switch (settings.status) {
      case SettingsStatus.Null:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('settings',
                  style: Theme.of(context).textTheme.headline4),
            ),
            RaisedButton(
              child: Text('refresh'),
              onPressed: settings.load,
              textColor: Theme.of(context).primaryColor,
            )
          ],
        );
      case SettingsStatus.Loading:
        return Center(child: CircularProgressIndicator());
      case SettingsStatus.Ready:
        return _buildSettingsList(settings.data, settings.store);
    }
    return null;
  }

  Widget _buildSettingsList(
      Map<String, dynamic> data, SaveSettingsMethod saver) {
    final translator = AppTranslations.of(context);

    return Directionality(
      textDirection:
          data['locale'] == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: SettingsList(
        sections: [
          SettingsSection(
            title: translator.text('settings_general'),
            tiles: [
              SettingsTile(
                title: translator.text('settings_general_language'),
                subtitle: data['locale'] == 'en' ? 'English' : 'العربية',
                leading: Icon(Icons.language),
                onTap: () {
                  setState(() {
                    data['locale'] = data['locale'] == 'en' ? 'ar' : 'en';
                    saveSettings(saver, data, () {
                      Toast.show(translator.text('settings_saved_successfully'),
                          context);
                    });
                    application.setLocale(data['locale']);
                  });
                },
              ),
              SettingsTile.switchTile(
                  leading: Icon(Icons.notifications),
                  title: translator.text('settings_notifications'),
                  onToggle: (bool value) {
                    setState(() {
                      data['notifications'] = value;
                      saveSettings(saver, data, () {
                        Toast.show(
                            translator.text('settings_saved_successfully'),
                            context);
                      });
                    });
                  },
                  switchValue: data['notifications']),
            ],
          ),
        ],
      ),
    );
  }

  void saveSettings(SaveSettingsMethod saver, Map<String, dynamic> data,
          Function onSaved) =>
      saver(data).then((v) => onSaved());
}
