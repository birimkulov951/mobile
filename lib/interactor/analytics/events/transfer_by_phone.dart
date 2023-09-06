/// События при переводе по номеру телефона
enum TransferByPhoneAnalyticsEvent {
  /// Пользователь выбрал банк для перевода денег при переводе по номеру телефона
  onBankSelected,

  /// Пользователь выбрал карту выбранного банка при переводе по номеру телефона
  onCardSelected,
}

extension TransferByPhoneAnalyticsEventValues on TransferByPhoneAnalyticsEvent {
  String get value {
    switch (this) {
      case TransferByPhoneAnalyticsEvent.onBankSelected:
        return 'transfer_bank_selected';
      case TransferByPhoneAnalyticsEvent.onCardSelected:
        return 'transfer_card_selected';
    }
  }
}
