import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/login_success_data.dart';
import 'package:mobile_ultra/interactor/auth/auth_interactor.dart';
import 'package:mobile_ultra/main.dart' show locale, pref;
import 'package:mobile_ultra/repositories/onboarding_repository.dart';
import 'package:mobile_ultra/screens/base/base_pin_state.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/onboarding/onboarding_screen.dart';
import 'package:mobile_ultra/screens/onboarding/route/onboarding_screen_route.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';

class PinCodeWidget extends StatefulWidget {
  final String phone;

  PinCodeWidget({
    required this.phone,
  });

  @override
  State<StatefulWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends BasePinState<PinCodeWidget> {
  String _pinCodeConfirm = '';
  String _message = '';

  @override
  void initState() {
    super.initState();
    _message = locale.getText('setup_pincode');
  }

  @override
  Widget get additionWidget => SizedBox();

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
            Title1(
                text: _message,
                padding: EdgeInsets.zero,
                size: 22,
                weight: FontWeight.w700,
                color: ColorNode.Dark1),
            Title1(
              text: 'user_phone',
              padding: const EdgeInsets.only(top: 24, bottom: 4),
              textAlign: TextAlign.center,
              size: 16,
              weight: FontWeight.w400,
              color: ColorNode.GreyScale500,
            ),
            Title1(
              text: formatStarsPhone(widget.phone),
              padding: EdgeInsets.zero,
              textAlign: TextAlign.center,
              size: 16,
              weight: FontWeight.w700,
              color: ColorNode.Dark1,
            ),
          ],
        ),
      );

  @override
  void onAdditionWidgetPressed() {}

  @override
  Future<bool> onBackPressed() async => true;

  @override
  void onPinEntered(String pin) {
    Future.delayed(Duration(milliseconds: 150), () {
      if (_pinCodeConfirm.isEmpty) {
        _message = locale.getText('repeat_pin');
        _pinCodeConfirm = pin;

        clearPin();
      } else {
        _trackPin(pin == _pinCodeConfirm);
        if (pin == _pinCodeConfirm) {
          savePin();
        } else {
          onErrorPin();
        }
      }
    });
  }

  void _trackPin(bool isConfirmPin) {
    if (AuthInteractor.instance.isRegistration) {
      AnalyticsInteractor.instance.registrationTracker.trackPinCreated(
        isConfirmPin: isConfirmPin,
      );
    } else {
      AnalyticsInteractor.instance.authTracker.trackPinCreated();
    }
  }

  void savePin() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pref?.setPin(aesEncrypt(_pinCodeConfirm, _pinCodeConfirm));
      pref?.setLaunchType(false);
      pref?.setLogin(widget.phone);
      pref?.setLoginedAccount(widget.phone);
      final OnboardingRepository onboardingRepository =
          inject<OnboardingRepository>();

      if (AuthInteractor.instance.isRegistration) {
        AnalyticsInteractor.instance.registrationTracker.trackSignupSuccess();
      } else {
        AnalyticsInteractor.instance.authTracker.trackLoginSuccess(
          LoginSuccessMethods.pin,
        );
      }

      if (!onboardingRepository.isOnboardingDisplayed) {
        Navigator.pushReplacementNamed(
          context,
          OnBoardingScreenRoute.Tag,
          arguments: mainOnboardingArguments,
        );
        AnalyticsInteractor.instance.onboardingTracker.trackOnboardingOpened();
      } else if (!onboardingRepository.isQuickPayOnboardingDisplayed &&
          onboardingRepository.isOnboardingDisplayed) {
        Navigator.of(context).pushNamed(
          OnBoardingScreenRoute.Tag,
          arguments: quickPayOnboardingArguments,
        );
      } else {
        Navigator.pushReplacementNamed(context, NavigationWidget.Tag);
      }
    });
  }
}
