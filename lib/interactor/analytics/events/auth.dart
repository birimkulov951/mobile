/// События авторизации
enum AuthAnalyticsEvent {
  /// Пользователь открывает приложение не в первый раз
  sessionOpen,

  /// Выполнен вход
  loginSuccess,

  /// Пользователь введ пароль
  authPasswordEntered,

  /// Введен ОТП
  authOtpEntered,

  /// Создан пин
  authPinCreated,
}

extension AuthAnalyticsEventValues on AuthAnalyticsEvent {
  String get value {
    switch (this) {
      case AuthAnalyticsEvent.sessionOpen:
        return 'session_open';
      case AuthAnalyticsEvent.loginSuccess:
        return 'login_success';
      case AuthAnalyticsEvent.authPasswordEntered:
        return 'auth_password_entered';
      case AuthAnalyticsEvent.authOtpEntered:
        return 'auth_otp_entered';
      case AuthAnalyticsEvent.authPinCreated:
        return 'auth_pin_created';
    }
  }
}
