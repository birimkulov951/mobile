import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  SharedPreferences? prefs;

  Future<Preference> init() async {
    if (!isInit) {
      prefs = await SharedPreferences.getInstance();
    }
    return this;
  }

  bool get isInit {
    return prefs != null;
  }

  Future setLastExpenditureResetDate(DateTime dateTime) async =>
      await prefs?.setString('last_date_time', dateTime.toString());

  DateTime? get getLastExpenditureResetDate =>
      prefs?.getString('last_date_time') == null
          ? null
          : DateTime.parse(prefs!.getString('last_date_time')!);

  Future setLaunchType(bool isFirst) async =>
      await prefs?.setBool('is_first', isFirst);

  bool get isFirstLaunch => prefs?.getBool('is_first') ?? true;

  Future<bool?> setAlreadyFirstOpen(bool isFirst) async =>
      await prefs?.setBool('launch_first_time', isFirst);

  bool get isAlreadyFirstOpen => prefs?.getBool('launch_first_time') ?? false;

  Future setLogin(String? login) async {
    if (login == null) {
      return await prefs?.remove('u_login');
    }

    return await prefs?.setString('u_login', login);
  }

  String get getLogin => prefs?.getString('u_login') ?? '';

  Future setViewLogin(String? login) async {
    if (login == null) {
      return prefs?.remove('u_view_login');
    }

    return await prefs?.setString('u_view_login', login);
  }

  String get getViewLogin => prefs?.getString('u_view_login') ?? '';

  Future setPrefix(String prefix) async =>
      await prefs?.setString('lang', prefix);

  String get prefix => prefs?.getString('lang') ?? LocaleHelper.Russian;

  /// Renamed theme value from 'theme' to 'theme_new'.
  /// Because darkTheme is not integrated yet.
  Future setCurrentTheme(int value) async =>
      await prefs?.setInt('theme_new', value);

  int get themeNode => prefs?.getInt('theme_new') ?? Brightness.light.index;

  Future setRefreshToken(String? token) async {
    if (token == null) {
      return prefs?.remove('refresh_token');
    }
    return await prefs?.setString('refresh_token', token);
  }

  String? get refreshToken => prefs?.getString('refresh_token');

  Future setAccessToken(String? token) async {
    if (token == null) {
      return await prefs?.remove('access_token');
    }

    return await prefs?.setString('access_token', token);
  }

  String? get accessToken => prefs?.getString('access_token');

  Future<void> setTokenType(String tokenType) async {
    await prefs?.setString('token_type', tokenType);
  }

  String? get tokenType => prefs?.getString('token_type');

  Future setFullName(String? name) async {
    if (name == null) {
      return prefs?.remove('full_name');
    }
    return await prefs?.setString('full_name', name);
  }

  String? get fullName => prefs?.getString('full_name');

  Future setActiveUser(bool? value) async {
    if (value == null) {
      return prefs?.remove('active_user');
    }
    return await prefs?.setBool('active_user', value);
  }

  bool get activeUser => prefs?.getBool('active_user') ?? false;

  Future setUserDocument(String? value) async {
    if (value == null) {
      return prefs?.remove('user_document');
    }
    return await prefs?.setString('user_document', value);
  }

  String get userDocument => prefs?.getString('user_document') ?? "";

  Future setUserBirthDate(String? value) async {
    if (value == null) {
      return await prefs?.remove('birth_date');
    }

    return await prefs?.setString('birth_date', value);
  }

  String get birthDate => prefs?.getString('birth_date') ?? "";

  Future setPin(String? value) async {
    if (value == null) {
      return await prefs?.remove('pincode');
    }
    return await prefs?.setString('pincode', value);
  }

  String? get pinCode => prefs?.getString('pincode');

  // TODO (khamidjon): remove faceId from preference in a couple of sprints
  bool get isUseFaceID => prefs?.getBool('faceId') ?? false;

  Future setUseFaceID(bool value) async =>
      await prefs?.setBool('faceId', value);

  Future madePay(bool value) async => await prefs?.setBool('madePay', value);

  bool get isMadePay => prefs?.getBool('madePay') ?? false;

  Future setAccUpdTime(int? time) async {
    if (time == null) {
      return prefs?.remove('accUpdTime');
    }
    return await prefs?.setInt('accUpdTime', time);
  }

  int get accUpdTime => prefs?.getInt('accUpdTime') ?? 0;

  bool get hideBalance => prefs?.getBool('hide_balance') ?? false;

  Future setConfigUpdateTime(int dateTime) async =>
      await prefs?.setInt('config_upd_time', dateTime);

  int get configUpdTime => prefs?.getInt('config_upd_time') ?? -1;

  Future setLogoUpdateTime(int dateTime) async =>
      await prefs?.setInt('logo_upd_time', dateTime);

  int get logoUpdTime => prefs?.getInt('logo_upd_time') ?? -1;

  Future setLatestNewsDate(int dateTime) async =>
      await prefs?.setInt('news_datetime', dateTime);

  int get latestNewsDate => prefs?.getInt('news_datetime') ?? -1;

  Future setAnimateWidgets(bool animate) async =>
      await prefs?.setBool('animate_widgets', animate);

  bool? get isAnimateWidgets => prefs?.getBool('animate_widgets');

  Future setHiddenCardBalance(List<String>? list) async {
    if (list == null) {
      return await prefs?.remove('balance_card_to_hidde');
    }
    return await prefs?.setStringList('balance_card_to_hidde', list);
  }

  List<String> get hiddenCardBalance =>
      prefs?.getStringList('balance_card_to_hidde') ?? [];

  Future setLoginedAccount(String? account) async {
    if (account == null) {
      return await prefs?.remove('logined_account');
    }
    return await prefs?.setString('logined_account', account);
  }

  String get loginedAccount => prefs?.getString('logined_account') ?? '';

  Future saveSuggestions(List<String>? suggestions) async {
    if (suggestions == null) {
      return await prefs?.remove('suggestions');
    }

    return await prefs?.setStringList('suggestions', suggestions);
  }

  List<String> get suggestionList => prefs?.getStringList('suggestions') ?? [];

  /*Future setScaleFactore(double scaleFactore) async =>
    await prefs?.setDouble('app_scale_factore', scaleFactore);
  double get getScaleFactore => prefs?.getDouble('app_scale_factore') ?? 1.0;*/

  Future acceptPhoneScaleFactore(bool accept) async =>
      await prefs?.setBool('accept_phone_scale_factore', accept);

  bool get isAcceptPhoneScaleFactore =>
      prefs?.getBool('accept_phone_scale_factore') ?? false;

  bool get isOnboardingDisplayed =>
      prefs?.getBool('is_onboarding_displayed') ?? false;
}
