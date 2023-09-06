/// Откуда был открыта оплата
enum PaymentOpenedSource {
  /// Из списка категорий
  categories,

  /// Из избранного
  favorites,

  /// После завершения сканирования qr
  qrScan,
}

extension PaymentOpenedSourceValue on PaymentOpenedSource {
  String get value {
    switch (this) {
      case PaymentOpenedSource.categories:
        return 'categories';
      case PaymentOpenedSource.favorites:
        return 'favorites';
      case PaymentOpenedSource.qrScan:
        return 'qr_scan';
    }
  }
}
