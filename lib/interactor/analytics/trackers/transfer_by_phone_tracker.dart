import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_by_phone_selected_type.dart';
import 'package:mobile_ultra/interactor/analytics/events/transfer_by_phone.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий при переводе по номеру телефона
class TransferByPhoneTracker extends BaseTracker {
  TransferByPhoneTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие выбора банка при переводе по номеру телефона
  void trackBankSelected() {
    analytics.logEvent(
      TransferByPhoneAnalyticsEvent.onBankSelected.value,
    );
  }

  /// Отправить событие выбора карты при переводе по номеру телефона
  void trackCardSelected(TransferByPhoneSelectedType type) {
    analytics.logEvent(
      TransferByPhoneAnalyticsEvent.onCardSelected.value,
      params: {
        'type': type.value,
      },
    );
  }
}
