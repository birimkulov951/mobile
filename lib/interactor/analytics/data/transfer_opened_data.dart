/// Откуда был открыт исходящий перевод
enum TransferOpenedSource {
  /// Кнопка пополнения на виджете кошелька
  walletCashin,

  /// Кнопка перевода на виджете кошелька
  walletCashout,

  /// Кнопка перехода на нижней панели навигации
  navbar,

  /// После завершения сканирования qr
  qrScan,
}

extension TransferOpenedSourceValue on TransferOpenedSource {
  String get value {
    switch (this) {
      case TransferOpenedSource.walletCashin:
        return 'wallet_cashin';
      case TransferOpenedSource.walletCashout:
        return 'wallet_cashout';
      case TransferOpenedSource.navbar:
        return 'navbar';
      case TransferOpenedSource.qrScan:
        return 'qr_scan';
    }
  }
}
