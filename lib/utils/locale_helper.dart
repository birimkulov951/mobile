import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile_ultra/di/di_container.dart';
import 'package:mobile_ultra/interactor/locale/locale_interactor.dart';

import 'package:mobile_ultra/main.dart' show pref;

class LocaleHelper {
  static const String Russian = 'ru';
  static const String Uzbek = 'uz';
  static const String English = 'en';

  static String currentLangCode = LocaleHelper.Russian;

  static final LocaleHelper instance = LocaleHelper();

  static late final _localeInteractor = getIt.get<LocaleInteractor>();

  LocaleHelper();

  static LocaleHelper of(BuildContext context) =>
      Localizations.of(context, LocaleHelper);

  static Future<LocaleHelper> load({Locale? locale}) async {
    if (locale == null)
      currentLangCode = pref!.prefix;
    else {
      currentLangCode = locale.languageCode;
      await pref!.setPrefix(currentLangCode);
    }

    String jsonContent = await rootBundle
        .loadString('assets/locale/localization_$currentLangCode.json');

    _localeInteractor.setLocaleTextData(json.decode(jsonContent));

    return LocaleHelper.instance;
  }

  String getText(String key) => _localeInteractor.getText(key);

  /// get - ru, en etc
  String get prefix => currentLangCode;

  Future<LocaleHelper> changeLanguage(String newLang) async =>
      await LocaleHelper.load(locale: Locale(newLang));
}

class LocaleHelperDelegate extends LocalizationsDelegate<LocaleHelper> {
  const LocaleHelperDelegate();

  @override
  bool isSupported(Locale locale) => [
        LocaleHelper.Uzbek,
        LocaleHelper.Russian,
        LocaleHelper.English
      ].contains(locale.languageCode);

  @override
  Future<LocaleHelper> load(Locale locale) => LocaleHelper.load();

  @override
  bool shouldReload(LocalizationsDelegate<LocaleHelper> old) => false;
}
