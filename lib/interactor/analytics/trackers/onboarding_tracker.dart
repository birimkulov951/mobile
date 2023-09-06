import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/onboarding_finished_type.dart';
import 'package:mobile_ultra/interactor/analytics/events/onboarding.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий онбординга
class OnboardingTracker extends BaseTracker {
  OnboardingTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие запуска онбординга
  void trackOnboardingOpened() {
    analytics.logEvent(
      OnboardingAnalyticsEvent.onboardingOpened.value,
    );
  }

  /// Отправить событие завершения онбординга
  void trackOnboardingFinished(OnboardingProgress type) {
    analytics.logEvent(
      OnboardingAnalyticsEvent.onboardingFinished.value,
      params: {
        'type': type.name,
      },
    );
  }
}
