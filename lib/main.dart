import 'package:drugStore/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'localization/app_translation_delegate.dart';
import 'localization/application.dart';
import 'partials/router.dart';
import 'partials/theme.dart';
import 'utils/state.dart';

void main() async {
  await DotEnv().load('assets/.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    // initCurrentLocale
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    final String title = Strings.applicationTitle;
    final StateModel state = new StateModel();

    return ScopedModel<StateModel>(
      model: state,
      child: MaterialApp(


        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeBuilder.getTheme(),
        initialRoute: Router.index,
        routes: Router.routes(),
        onGenerateRoute: Router.onGenerateRoute,
        onUnknownRoute: Router.onUnknownRoute,
        localizationsDelegates: [
          _newLocaleDelegate,
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("ar", ""),
          const Locale("en", ""),
        ],
      ),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
