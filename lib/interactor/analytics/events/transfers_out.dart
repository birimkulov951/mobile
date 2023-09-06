/// События исходящих переводов
enum TransfersOutAnalyticsEvent {
  /// Пользователь открыл экран перевода денег
  transferOpened,

  /// Откуда перевести деньги
  transferSourceSelected,

  /// Куда перевести деньги
  transferDestinationSelected,

  /// Пользователь подтвердил перевод
  transferConfirmed,

  /// Пользователь ввел OTP-код из SMS
  transferOtpEntered,

  /// Пользователь нажал кнопку повторной отправки SMS
  transferOtpResend,

  /// Пользователь нажал кнопку «Поделиться кодом перевода»
  /// (доступно только для переводов по номеру телефона)
  transferCodeShare,

  /// Перевод был выполнен
  transferSuccess,
}

extension TransfersOutAnalyticsEventValues on TransfersOutAnalyticsEvent {
  String get value {
    switch (this) {
      case TransfersOutAnalyticsEvent.transferOpened:
        return 'transfer_opened';

      case TransfersOutAnalyticsEvent.transferSourceSelected:
        return 'transfer_source_selected';

      case TransfersOutAnalyticsEvent.transferDestinationSelected:
        return 'transfer_destination_selected';

      case TransfersOutAnalyticsEvent.transferConfirmed:
        return 'transfer_confirmed';

      case TransfersOutAnalyticsEvent.transferOtpEntered:
        return 'transfer_otp_entered';

      case TransfersOutAnalyticsEvent.transferOtpResend:
        return 'transfer_otp_resend';

      case TransfersOutAnalyticsEvent.transferCodeShare:
        return 'transfer_code_share';

      case TransfersOutAnalyticsEvent.transferSuccess:
        return 'transfer_success';
    }
  }
}
