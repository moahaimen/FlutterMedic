import 'dart:ui';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<String> supportedLanguages = [
    "English",
    "العربية",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "ar",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;

  void setLocale(String languageCode) {
    final locale = application
        .supportedLocales()
        .firstWhere((element) => element.languageCode == languageCode);

    if (locale == null) {
      throw Exception("Bad argument $languageCode");
    }
    this.onLocaleChanged(locale);
  }
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
