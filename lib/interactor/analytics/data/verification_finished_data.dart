/// Типы документа для сканирования на этапе верификации
enum VerificationResults {
  success,
  fail,
  serviceDown,
}

extension VerificationResultsValue on VerificationResults {
  String get value {
    switch (this) {
      case VerificationResults.success:
        return 'success';
      case VerificationResults.fail:
        return 'fail';
      case VerificationResults.serviceDown:
        return 'service_down';
    }
  }
}
