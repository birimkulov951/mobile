abstract class OnboardingRepository {
  bool get isOnboardingDisplayed;

  Future<void> setIsOnboardingDisplayed(final bool isDisplayed);

  bool get isQuickPayOnboardingDisplayed;

  Future<void> setIsQuickPayOnboardingDisplayed(final bool isDisplayed);
}
