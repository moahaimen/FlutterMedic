import 'package:drugStore/components/settings_form.dart';
import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:drugStore/partials/drawer.dart';
import 'package:drugStore/partials/toolbar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    return Scaffold(
      drawer: DrawerBuilder.build(context, AppRouter.settings),
      appBar: Toolbar.get(title: AppRouter.settings, context: context),
      body: Directionality(
          textDirection: translator.locale.languageCode == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: SettingsForm()),
    );
  }
}
