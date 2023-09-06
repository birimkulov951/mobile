import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/payment_opened_data.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_source_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/payment.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер событий оплаты
class PaymentTracker extends BaseTracker {
  PaymentTracker(Analytics analyticsService) : super(analyticsService);

  /// Открыт экран оплаты
  void trackOpened({
    PaymentOpenedSource? source,
    int? merchantId,
  }) {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentOpened.value,
      params: {
        'background': source?.value,
        'merchant_id': merchantId,
      },
    );
  }

  /// Откуда платить
  void trackSelected({
    TransferSourceTypes? source,
  }) {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentSourceSelected.value,
      params: {
        'type': source?.value,
      },
    );
  }

  /// Пользователь подтвердил платеж
  void trackConfirmed({
    TransferSourceTypes? source,
    int? merchantId,
    num? amount,
  }) {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentConfirmed.value,
      params: {
        'source': source?.value,
        'merchant_id': merchantId,
        'amount': amount,
      },
    );
  }

  /// Пользователь подтвердил платеж
  void trackOtpEntered({
    required VerificationResults result,
  }) {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentOtpEntered.value,
      params: {
        'result': result.value,
      },
    );
  }

  /// Пользователь нажал кнопку повторной отправки SMS
  void trackOtpResend() {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentOtpResend.value,
    );
  }

  /// Платеж был выполнен успешно
  void trackSuccess({
    TransferSourceTypes? source,
    int? merchantId,
    num? amount,
    bool? isFastPay,
  }) {
    analytics.logEvent(
      PaymentAnalyticsEvent.paymentSuccess.value,
      params: {
        'source': source?.value,
        'merchant_id': merchantId,
        'amount': amount,
        'fast_pay': isFastPay,
      },
    );
  }
}
