/// Типы документа для сканирования на этапе верификации
enum VerificationScanDocuments {
  /// Пасспорт
  passport,

  /// ID
  id,
}

extension VerificationScanDocumentsValue on VerificationScanDocuments {
  String get value {
    switch (this) {
      case VerificationScanDocuments.passport:
        return 'passport';
      case VerificationScanDocuments.id:
        return 'id';
    }
  }
}
