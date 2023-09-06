/// В каком списке выбрана карта для оплаты
enum TransferByPhoneSelectedType {
  /// Список карт Paynet
  paynetList,

  /// Список карт других банков
  apiList,
}

extension TransferByPhoneSelectedTypeValues on TransferByPhoneSelectedType {
  String get value {
    switch (this) {
      case TransferByPhoneSelectedType.paynetList:
        return 'paynet_list';
      case TransferByPhoneSelectedType.apiList:
        return 'api_list';
    }
  }
}
