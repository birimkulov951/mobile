import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_source_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/transfers_in.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий входящих переводов
class TransfersInTracker extends BaseTracker {
  TransfersInTracker(Analytics analyticsService) : super(analyticsService);

  /// TODO доделать использование,
  /// на данный момент входящие переводы не обновляются в реальном времени
  ///
  /// Отправить событие зарегистрированного
  /// нового входящего денежного перевода по телефону
  void trackRegistered() {
    analytics.logEvent(
      TransfersInAnalyticsEvent.transferInboundRegistered.value,
    );
  }

  /// Пользователь ввел ОТП код
  void trackOtpEntered({
    required VerificationResults result,
  }) {
    analytics.logEvent(
      TransfersInAnalyticsEvent.transferInboundOtpEntered.value,
      params: {
        'result': result.value,
      },
    );
  }

  /// Пользователь выбрал карту для получения денег
  void trackCardSelected({
    required TransferSourceTypes destination,
  }) {
    analytics.logEvent(
      TransfersInAnalyticsEvent.transferInboundCardSelected.value,
      params: {
        'result': destination.value,
      },
    );
  }

  /// Деньги получены
  void trackSuccess({
    required TransferSourceTypes destination,
  }) {
    analytics.logEvent(
      TransfersInAnalyticsEvent.transferInboundSuccess.value,
      params: {
        'result': destination.value,
      },
    );
  }
}
