/// События оплаты
enum PaymentAnalyticsEvent {
  /// Открыт экран оплаты
  paymentOpened,

  /// Откуда платить
  paymentSourceSelected,

  /// Пользователь подтвердил платеж
  paymentConfirmed,

  /// Пользователь ввел OTP-код из SMS
  paymentOtpEntered,

  /// Пользователь нажал кнопку повторной отправки SMS
  paymentOtpResend,

  /// Платеж был выполнен успешно
  paymentSuccess,
}

extension PaymentAnalyticsEventValues on PaymentAnalyticsEvent {
  String get value {
    switch (this) {
      case PaymentAnalyticsEvent.paymentOpened:
        return 'payment_opened';
      case PaymentAnalyticsEvent.paymentSourceSelected:
        return 'payment_source_selected';
      case PaymentAnalyticsEvent.paymentConfirmed:
        return 'payment_confirmed';
      case PaymentAnalyticsEvent.paymentOtpEntered:
        return 'payment_otp_entered';
      case PaymentAnalyticsEvent.paymentOtpResend:
        return 'payment_otp_resend';
      case PaymentAnalyticsEvent.paymentSuccess:
        return 'payment_success';
    }
  }
}
