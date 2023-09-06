/// Откуда был открыт исходящий перевод
enum TransferTargetOwnerType {
  /// Перевод другим людям
  other,

  /// Перевод себе
  myself,
}

extension TransferTargetOwnerTypeValue on TransferTargetOwnerType {
  String get value {
    switch (this) {
      case TransferTargetOwnerType.other:
        return 'other';
      case TransferTargetOwnerType.myself:
        return 'myself';
    }
  }
}
