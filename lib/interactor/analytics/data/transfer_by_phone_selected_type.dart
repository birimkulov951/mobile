/// В каком списке выбрана карта для оплаты
enum TransferByPhoneSelectedType {
  /// Список карт Pynet
  pynetList,

  /// Список карт других банков
  apiList,
}

extension TransferByPhoneSelectedTypeValues on TransferByPhoneSelectedType {
  String get value {
    switch (this) {
      case TransferByPhoneSelectedType.pynetList:
        return 'pynet_list';
      case TransferByPhoneSelectedType.apiList:
        return 'api_list';
    }
  }
}
