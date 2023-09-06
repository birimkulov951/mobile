import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/events/registration.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий регистрации
class RegistrationTracker extends BaseTracker {
  RegistrationTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие первой авторизации
  void trackLaunchFirstTime() {
    analytics.logEvent(
      RegistrationAnalyticsEvent.launchFirstTime.value,
    );
  }

  /// Отправить событие ввода пользователем номера телефона
  void trackPhoneNumberEntered({required bool isError}) {
    analytics.logEvent(
      RegistrationAnalyticsEvent.registrationPhoneNumberEntered.value,
      params: {'error': isError},
    );
  }

  /// Отправить событие ввода ОТП кода из смс
  void trackOtpEntered({
    required bool isPhoneRegistered,
    required bool isCorrectCode,
  }) {
    analytics.logEvent(
      RegistrationAnalyticsEvent.registrationOtpEntered.value,
      params: {
        'phone_registered': isPhoneRegistered,
        'result': isCorrectCode ? 'success' : 'fail',
      },
    );
  }

  /// Отправить событие пользователь нажал кнопку повторной отправки SMS
  void trackOtpResent() {
    analytics.logEvent(RegistrationAnalyticsEvent.registrationOtpResent.value);
  }

  /// Пользователь ввел пароль в оба поля (пароль и повторный пароль)
  void trackPasswordEntered({required bool isValidationPasswordError}) {
    analytics.logEvent(
      RegistrationAnalyticsEvent.registrationPasswordEntered.value,
      params: {
        'error': isValidationPasswordError,
      },
    );
  }

  /// Пользователь создал PIN-код после выполнения шагов ввода и повторения
  void trackPinCreated({required bool isConfirmPin}) {
    analytics.logEvent(
      RegistrationAnalyticsEvent.registrationPinCreated.value,
      params: {
        'error': !isConfirmPin,
      },
    );
  }

  /// Регистрация завершена
  void trackSignupSuccess() {
    analytics.logEvent(RegistrationAnalyticsEvent.signupSuccess.value);
  }
}
