/// Типы переводов
enum TransferSourceTypes {
  uzcard,
  humo,
  wallet,
}

extension TransferSourceTypesValues on TransferSourceTypes {
  String get value {
    switch (this) {
      case TransferSourceTypes.uzcard:
        return 'uzcard';
      case TransferSourceTypes.humo:
        return 'humo';
      case TransferSourceTypes.wallet:
        return 'wallet';
    }
  }
}
