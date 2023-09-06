/// События регистрации
enum RegistrationAnalyticsEvent {
  /// Первая авторизация
  launchFirstTime,

  /// Пользователь ввел номер телефона
  registrationPhoneNumberEntered,

  /// Пользователь ввел ОТП код из смс
  registrationOtpEntered,

  /// Пользователь нажал кнопку повторной отправки SMS
  registrationOtpResent,

  /// Пользователь ввел пароль в оба поля (пароль и повторный пароль)
  registrationPasswordEntered,

  /// Пользователь создал PIN-код после выполнения шагов ввода и повторения
  registrationPinCreated,

  /// Регистрация завершена
  signupSuccess,
}

extension RegistrationAnalyticsEventValues on RegistrationAnalyticsEvent {
  String get value {
    switch (this) {
      case RegistrationAnalyticsEvent.launchFirstTime:
        return 'launch_first_time';

      case RegistrationAnalyticsEvent.registrationPhoneNumberEntered:
        return 'registration_phone_number_entered';

      case RegistrationAnalyticsEvent.registrationOtpEntered:
        return 'registration_otp_entered';

      case RegistrationAnalyticsEvent.registrationOtpResent:
        return 'registration_otp_resent';

      case RegistrationAnalyticsEvent.registrationPasswordEntered:
        return 'registration_password_entered';

      case RegistrationAnalyticsEvent.registrationPinCreated:
        return 'registration_pin_created';

      case RegistrationAnalyticsEvent.signupSuccess:
        return 'signup_success';
    }
  }
}
