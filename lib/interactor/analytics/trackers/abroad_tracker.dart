import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/abroad_transfer_country.dart';
import 'package:mobile_ultra/interactor/analytics/data/destination_selected_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_source_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/abroad.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий перевода за границу
class AbroadTracker extends BaseTracker {
  AbroadTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие открытия экрана международных переводов,
  /// чтобы выбрать страну назначения
  void trackOpened() {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferIntOpened.value,
    );
  }

  /// Отправить событие выбора страны для международного перевода
  void trackCountrySelected(AbroadTransferCountry country) {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferIntCountrySelected.value,
      params: {
        'country': country.name,
      },
    );
  }

  /// Отправить событие выбра карты для перевода денег
  void trackDestinationSelected(DestinationSelectedType type) {
    analytics.logEvent(
        AbroadAnalyticsEvent.transferIntDestinationSelected.value,
        params: {
          'type': type.value,
        });
  }

  /// Отправить событие нажатия на кнопку «Продолжить» на экране конверсии
  void trackConverted() {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferIntConverted.value,
    );
  }

  /// Отправить событие подтверждения перевода денег
  void trackConfirmed({
    String? destination,
    TransferSourceTypes? source,
    required double amount,
  }) {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferIntConfirmed.value,
      params: {
        'destination': destination,
        'source': source?.value,
        'amount': amount,
      },
    );
  }

  /// Отправить событие ввода OTP-кода из SMS
  void trackOtpEntered({
    required VerificationResults result,
  }) {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferOtpEntered.value,
    );
  }

  /// Отправить событие нажатия на кнопку повторной отправки SMS
  void trackOtpResend() {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferOtpResend.value,
    );
  }

  /// Отправить событие выполненного перевода
  void trackSuccess({
    required String? destination,
    TransferSourceTypes? source,
    required double? amount,
  }) {
    analytics.logEvent(
      AbroadAnalyticsEvent.transferIntSuccess.value,
      params: {
        'destination': destination,
        'source': source?.value,
        'amount': amount,
      },
    );
  }
}
