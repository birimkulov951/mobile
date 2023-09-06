import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/login_success_data.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/auth/auth_pin_screen_wm.dart';
import 'package:mobile_ultra/screens/base/base_pin_state.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_screen.dart';
import 'package:mobile_ultra/screens/onboarding/route/onboarding_screen_route.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_route.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/route_utils.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class AuthPinWidget extends StatefulWidget {
  const AuthPinWidget({
    super.key,
    required this.wm,
  });

  final IAuthPinScreenWidgetModel wm;

  @override
  State<AuthPinWidget> createState() => AuthPinWidgetState();
}

class AuthPinWidgetState extends BasePinState<AuthPinWidget>
    with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();

  late bool reLogin = getBoolArgumentFromContext(context);

  String? login, password;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorNode.ContainerColor,
      statusBarIconBrightness: Brightness.dark,
    ));
    if (widget.wm.isBiometricsEnabled)
      Future.delayed(Duration(milliseconds: 500), () => onBiometricAuth());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) auth.stopAuthentication();
  }

  @override
  Widget get additionWidget => TextLocale(
        'forgot_code',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorNode.GreyScale500,
        ),
      );

  @override
  Widget get headerWidget => Container(
        height: MediaQuery.of(context).size.height * .38,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SvgPicture.asset('assets/graphics/paynet.svg'),
            ),
            const Spacer(),
            TextLocale(
              "input_pin",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ColorNode.Dark1,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextLocale(
              "user_phone",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorNode.GreyScale500,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              formatStarsPhone(pref?.getLogin),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ColorNode.Dark1,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Future<bool> onBackPressed() async {
    if (reLogin) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => showMessage(context,
              locale.getText('attention'), locale.getText('confirm_to_exit'),
              dismissTitle: locale.getText('cancel'),
              onDismiss: () => Navigator.pop(context),
              onSuccess: () => SystemNavigator.pop()));
    }
    return !reLogin;
  }

  @override
  void onAdditionWidgetPressed() => forgotCode();

  @override
  void onPinEntered(String pin) {
    if (showLoading) {
      return;
    }

    Future.delayed(Duration(milliseconds: 150), () {
      if (pref?.pinCode == null) {
        onErrorPin();
        return;
      }

      String savedPin = aesDecrypt(pin, pref!.pinCode!);
      if (pin == savedPin) {
        AnalyticsInteractor.instance.authTracker.trackLoginSuccess(
          LoginSuccessMethods.pin,
        );
        attemptAuth();
      } else {
        onErrorPin();
      }
    });
  }

  void onLogin({String? errorMessage, bool confirmBySMS = false}) async {
    setState(() => showLoading = false);
    dynamic result = true;

    if (errorMessage != null && !confirmBySMS) {
      onFail(_errorMessageDesc(errorMessage));
      return;
    }

    if (confirmBySMS) {
      result = await Navigator.pushReplacementNamed(
            context,
            OtpConfirmationScreenRoute.Tag,
            arguments: OtpConfirmationScreenArguments(
              phoneNumber: login!,
              isAuth: true,
            ),
          ) ??
          false;
    }

    if (result) {
      if (login != null) {
        pref?.setViewLogin(login!);
        pref?.setLoginedAccount(login!);
      }

      if (!reLogin) {
        if (!widget.wm.isQuickPayOnboardingDisplayed &&
            widget.wm.isOnboardingDisplayed) {
          Navigator.of(context).pushNamed(
            OnBoardingScreenRoute.Tag,
            arguments: quickPayOnboardingArguments,
          );
        } else {
          Navigator.pushReplacementNamed(context, NavigationWidget.Tag);
        }
      } else {
        Navigator.pop(context, !reLogin);
      }
    }
  }

  Future<void> forgotCode() async {
    final result = await viewModalSheet<bool?>(
            context: context,
            child: Container(
              height: 320,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: TextLocale(
                      "forgot_pin",
                      style: TextStyles.title4,
                    ),
                  ),
                  TextLocale(
                    "forgot_pin_hint",
                    style: TextStyles.textRegular,
                  ),
                  Spacer(),
                  RoundedButton(
                    title: 'logout',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
            )) ??
        false;

    if (result) {
      pref?.setLaunchType(true);
      pref?.setAccessToken(null);
      pref?.setRefreshToken(null);
      pref?.setConfigUpdateTime(-1);
      pref?.setLogoUpdateTime(-1);
      pref?.setViewLogin(null);
      pref?.setPin(null);
      pref?.setFullName(null);
      pref?.setActiveUser(null);
      pref?.setUserBirthDate(null);
      pref?.setUserDocument(null);
      pref?.madePay(false);
      pref?.setHiddenCardBalance(null);
      pref?.setLoginedAccount(null);
      pref?.saveSuggestions(null);
      pref?.setAccUpdTime(null);
      pref?.acceptPhoneScaleFactore(false);

      homeData = null;
      accountList.clear();
      reminderList.clear();
      favoriteList.clear();
      suggestionList.clear();
      sharingData = null;
      requestedFavorites = false;
      startFrom = NavigationWidget.HOME;

      try {
        await firebaseMessaging.unsubscribeFromTopic('global');
        await firebaseMessaging.unsubscribeFromTopic(locale.prefix);
      } on Object catch (e) {
        printLog(e);
      }

      await db?.clearAll();
      await DefaultCacheManager().emptyCache();

      Navigator.pushNamedAndRemoveUntil(
        context,
        PhoneNumberLoginScreenRoute.Tag,
        (Route<dynamic> route) => false,
        arguments: PhoneNumberLoginScreenArguments(forgotPassword: true),
      );
    }
  }

  void onBiometricAuth() async {
    bool resultAuth = false;

    try {
      resultAuth = await auth.authenticate(
        biometricOnly: true,
        localizedReason: 'Face ID',
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: AndroidAuthMessages(
          signInTitle: locale.getText((pref?.isUseFaceID ?? false)
              ? 'faceid_auth'
              : 'fingerprint_auth'),
          biometricHint: '',
          biometricRequiredTitle: '',
          cancelButton: locale.getText('cancel'),
        ),
      );
    } on PlatformException catch (e) {
      printLog(e.message ?? 'auth exception null');
    } on Object catch (e) {
      /// TODO может ли быть null?
      printLog(e.toString());
    }

    if (resultAuth) {
      AnalyticsInteractor.instance.authTracker.trackLoginSuccess(
        LoginSuccessMethods.biometry,
      );
      attemptAuth();
    }
  }

  void attemptAuth() {
    setState(() {
      pause = false;
      showLoading = true;
    });
    widget.wm.login(
      onLogin: onLogin,
    );
  }

  String _errorMessageDesc(String message) {
    switch (message) {
      case 'version_too_old':
        return locale.getText('version_too_old');
      default:
        return message;
    }
  }
}
