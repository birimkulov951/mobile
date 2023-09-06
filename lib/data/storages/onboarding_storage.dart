import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/main.dart';

@injectable
class OnboardingStorage {
  const OnboardingStorage(this._localStorage);

  final Box _localStorage;

  Future<void> setIsOnboardingDisplayed(final bool isDisplayed) async =>
      await _localStorage.put('is_onboarding_displayed', isDisplayed);

  bool get isOnboardingDisplayed =>
      _localStorage.get('is_onboarding_displayed') ??
      pref!.isOnboardingDisplayed;

  Future<void> setIsQuickPayOnboardingDisplayed(final bool isDisplayed) async =>
      await _localStorage.put('is_quick_pay_onboarding_displayed', isDisplayed);

  bool get isQuickPayOnboardingDisplayed =>
      _localStorage.get('is_quick_pay_onboarding_displayed') ?? false;
}
