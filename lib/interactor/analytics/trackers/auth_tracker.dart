import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/login_success_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/auth.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий авторизации
class AuthTracker extends BaseTracker {
  AuthTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие первой авторизации
  void trackSessionOpen() {
    analytics.logEvent(
      AuthAnalyticsEvent.sessionOpen.value,
    );
  }

  /// Отправить событие выполненного входа
  void trackLoginSuccess(LoginSuccessMethods method) {
    analytics.logEvent(
      AuthAnalyticsEvent.loginSuccess.value,
      params: {
        'method': method.value,
      },
    );
  }

  /// Отправить событие пользователь ввел пароль
  void trackPasswordEntered() {
    analytics.logEvent(
      AuthAnalyticsEvent.authPasswordEntered.value,
    );
  }

  /// Отправить событие введен ОТП
  void trackOtpEntered() {
    analytics.logEvent(
      AuthAnalyticsEvent.authOtpEntered.value,
    );
  }

  /// Отправить событие создан пин
  void trackPinCreated() {
    analytics.logEvent(
      AuthAnalyticsEvent.authPinCreated.value,
    );
  }
}
