/// События верификации
enum VerificationAnalyticsEvent {
  /// Пользователь открыл поток проверки (1-й экран, открывается автоматически)
  verificationInfoOpened,

  /// Пользователь прошел этап сканирования
  verificationScanPassed,

  /// Пользователь прошел этап проверки селфи
  verificationSelfiePassed,

  /// Проверка завершена с некоторым результатом
  verificationFinished,
}

extension VerificationAnalyticsEventValues on VerificationAnalyticsEvent {
  String get value {
    switch (this) {
      case VerificationAnalyticsEvent.verificationInfoOpened:
        return 'verification_info_opened';
      case VerificationAnalyticsEvent.verificationScanPassed:
        return 'verification_scan_passed';
      case VerificationAnalyticsEvent.verificationSelfiePassed:
        return 'verification_selfie_passed';
      case VerificationAnalyticsEvent.verificationFinished:
        return 'verification_finished';
    }
  }
}
