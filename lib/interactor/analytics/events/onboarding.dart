/// События онбординга
enum OnboardingAnalyticsEvent {
  /// Онбординг запущен
  onboardingOpened,

  /// Онбординг завершен
  onboardingFinished,
}

extension OnboardingAnalyticsEventValues on OnboardingAnalyticsEvent {
  String get value {
    switch (this) {
      case OnboardingAnalyticsEvent.onboardingOpened:
        return 'onboarding_opened';
      case OnboardingAnalyticsEvent.onboardingFinished:
        return 'onboarding_finished';
    }
  }
}
