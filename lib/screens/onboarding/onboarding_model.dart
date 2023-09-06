import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/onboarding_repository.dart';

class OnBoardingElementaryModel extends ElementaryModel {
  OnBoardingElementaryModel(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  Future<void> setOnboardingProgress(final bool isDisplayed) async =>
      _onboardingRepository.setIsOnboardingDisplayed(isDisplayed);

  Future<void> setQuickPayOnboardingProgress(final bool isDisplayed) async =>
      _onboardingRepository.setIsQuickPayOnboardingDisplayed(isDisplayed);
}
