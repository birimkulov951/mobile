/// События входящих платежей
enum TransfersInAnalyticsEvent {
  /// Зарегистрирован новый входящий денежный перевод по телефону
  transferInboundRegistered,

  /// Пользователь ввел OTP-код
  transferInboundOtpEntered,

  /// Пользователь выбрал карту для получения денег
  transferInboundCardSelected,

  /// Деньги получены
  transferInboundSuccess,
}

extension TransfersInAnalyticsEventValues on TransfersInAnalyticsEvent {
  String get value {
    switch (this) {
      case TransfersInAnalyticsEvent.transferInboundRegistered:
        return 'transfer_inbound_registered';
      case TransfersInAnalyticsEvent.transferInboundOtpEntered:
        return 'transfer_inbound_otp_entered';
      case TransfersInAnalyticsEvent.transferInboundCardSelected:
        return 'transfer_inbound_card_selected';
      case TransfersInAnalyticsEvent.transferInboundSuccess:
        return 'transfer_inbound_success';
    }
  }
}
