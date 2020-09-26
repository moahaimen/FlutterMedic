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
              _buildSettingsBody(model)),
    );
  }

  Widget _buildSettingsBody(StateModel model) {
    switch (model.settings.status) {
      case SettingsStatus.Null:
        model.settings.load();
        return Center(child: CircularProgressIndicator());
      case SettingsStatus.Loading:
        return Center(child: CircularProgressIndicator());
      case SettingsStatus.Ready:
        return _buildSettingsList(model.settings.data, model.storeSettings);
    }
    return null;
  }

  Widget _buildSettingsList(
    Map<String, dynamic> settings,
    Future<void> Function(Map<String, dynamic>) set,
  ) {
    final translator = AppTranslations.of(context);

    return Directionality(
      textDirection:
          settings['locale'] == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: SettingsList(
        sections: [
          SettingsSection(
            title: translator.text('settings_general'),
            tiles: [
              SettingsTile(
                title: translator.text('settings_general_language'),
                subtitle: settings['locale'] == 'en' ? 'English' : 'العربية',
                leading: Icon(Icons.language),
                onTap: () {
                  setState(() {
                    settings['locale'] =
                        settings['locale'] == 'en' ? 'ar' : 'en';
                    saveSettings(set, settings, translator, context);
                    application.setLocale(settings['locale']);
                  });
                },
              ),
              SettingsTile.switchTile(
                  leading: Icon(Icons.notifications),
                  title: translator.text('settings_notifications'),
                  onToggle: (bool value) {
                    setState(() {
                      settings['notifications'] = value;
                      saveSettings(set, settings, translator, context);
                    });
                  },
                  switchValue: settings['notifications']),
            ],
          ),
        ],
      ),
    );
  }

  void saveSettings(
      Future<void> Function(Map<String, dynamic>) saver,
      Map<String, dynamic> data,
      AppTranslations translator,
      BuildContext context) {
    saver(data).then((value) =>
        Toast.show(translator.text('settings_saved_successfully'), context));
  }
}
