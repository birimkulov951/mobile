import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_opened_data.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_source_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_target_owner_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/transfers_out.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий исходящих переводов
class TransfersOutTracker extends BaseTracker {
  TransfersOutTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие открытия экрана перевода денег
  void trackTransferOpened({
    required TransferOpenedSource source,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferOpened.value,
      params: {
        'background': source.value,
      },
    );
  }

  /// Откуда перевести деньги
  void trackSourceSelected({
    TransferSourceTypes? sourceType,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferSourceSelected.value,
      params: {
        'type': sourceType?.value,
      },
    );
  }

  /// Куда перевести деньги
  void trackDestinationSelected({
    required TransferDestinationType? destinationType,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferDestinationSelected.value,
      params: {
        'type': destinationType?.value,
      },
    );
  }

  /// Пользователь подтвердил перевод
  void trackConfirmed({
    required TransferTargetOwnerType targetType,
    required TransferSourceTypes? source,
    required TransferDestinationType? destinationType,
    required num? amount,
    required bool isEnteredComment,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferConfirmed.value,
      params: {
        'type': targetType.value,
        'source': source?.value,
        'destination': destinationType?.value,
        'amount': amount,
        'comment': isEnteredComment,
      },
    );
  }

  /// Пользователь ввел OTP-код из SMS
  void trackOtpEntered({
    required VerificationResults result,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferOtpEntered.value,
      params: {
        'result': result.value,
      },
    );
  }

  /// Пользователь нажал кнопку повторной отправки SMS
  void trackOtpResend() {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferOtpResend.value,
    );
  }

  /// Пользователь нажал кнопку «Поделиться кодом перевода»
  /// (доступно только для переводов по номеру телефона)
  void trackCodeShare() {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferCodeShare.value,
    );
  }

  /// Перевод был выполнен
  void trackTransferSuccess({
    TransferTargetOwnerType? ownerType,
    TransferSourceTypes? source,
    TransferDestinationType? destinationType,
    num? amount,
    num? comission,
    bool? isEnteredComment,
  }) {
    analytics.logEvent(
      TransfersOutAnalyticsEvent.transferSuccess.value,
      params: {
        'type': ownerType?.value,
        'source': source?.value,
        'destination': destinationType?.value,
        'amount': amount,
        'comission': comission,
        'comment': isEnteredComment,
      },
    );
  }
}
