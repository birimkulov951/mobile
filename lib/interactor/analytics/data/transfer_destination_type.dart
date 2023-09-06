/// Куда перевести деньги
enum TransferDestinationType {
  /// Привязанная карта
  cardLinked,

  /// Внешняя карта
  cardExternal,

  /// Кошелек
  wallet,

  /// Телефон
  phone,
}

extension TransferDestinationTypeValues on TransferDestinationType {
  String get value {
    switch (this) {
      case TransferDestinationType.cardLinked:
        return 'card_linked';
      case TransferDestinationType.cardExternal:
        return 'card_external';
      case TransferDestinationType.wallet:
        return 'wallet';
      case TransferDestinationType.phone:
        return 'phone';
    }
  }
}
