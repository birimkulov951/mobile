import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_scan_data.dart';
import 'package:mobile_ultra/interactor/analytics/events/verification.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер собыий верификации
class VerificationTracker extends BaseTracker {
  VerificationTracker(Analytics analyticsService) : super(analyticsService);

  /// Отправить событие первой авторизации
  void trackInfoOpened() {
    analytics.logEvent(
      VerificationAnalyticsEvent.verificationInfoOpened.value,
    );
  }

  /// Отправить событие пройденного этапа сканирования
  void trackScanPassed(VerificationScanDocuments documentType) {
    analytics.logEvent(
      VerificationAnalyticsEvent.verificationScanPassed.value,
      params: {
        'document_selected': documentType.value,
      },
    );
  }

  /// Отправить событие пройденного этап проверки селфи
  void trackSelfiePassed() {
    analytics.logEvent(
      VerificationAnalyticsEvent.verificationSelfiePassed.value,
    );
  }

  /// Отправить событие завершения проверки с некоторым результатом
  void trackFinished(VerificationResults resultType) {
    analytics.logEvent(
      VerificationAnalyticsEvent.verificationFinished.value,
      params: {
        'result': resultType.value,
      },
    );
  }
}
