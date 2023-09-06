/// События авторизации
enum AbroadAnalyticsEvent {
  /// Пользователь открывает экран международных переводов,
  /// чтобы выбрать страну назначения
  transferIntOpened,

  /// Пользователь выбрал страну для международного перевода
  transferIntCountrySelected,

  /// Пользователь выбрал карту для перевода денег
  transferIntDestinationSelected,

  /// Пользователь нажал кнопку «Продолжить» на экране конверсии
  transferIntConverted,

  /// Пользователь подтвердил перевод денег
  transferIntConfirmed,

  /// Пользователь ввел OTP-код из SMS
  transferOtpEntered,

  /// Пользователь нажал кнопку повторной отправки SMS
  transferOtpResend,

  /// Перевод был выполнен
  transferIntSuccess,
}

extension AbroadAnalyticsEventValues on AbroadAnalyticsEvent {
  String get value {
    switch (this) {
      case AbroadAnalyticsEvent.transferIntOpened:
        return 'transfer_int_opened';
      case AbroadAnalyticsEvent.transferIntCountrySelected:
        return 'transfer_int_country_selected';
      case AbroadAnalyticsEvent.transferIntDestinationSelected:
        return 'transfer_int_destination_selected';
      case AbroadAnalyticsEvent.transferIntConverted:
        return 'transfer_int_converted';
      case AbroadAnalyticsEvent.transferIntConfirmed:
        return 'transfer_int_confirmed';
      case AbroadAnalyticsEvent.transferOtpEntered:
        return 'transfer_otp_entered';
      case AbroadAnalyticsEvent.transferOtpResend:
        return 'transfer_otp_resend';
      case AbroadAnalyticsEvent.transferIntSuccess:
        return 'transfer_int_success';
    }
  }
}
