enum DestinationSelectedType {
  newCard,
  previousCard,
}

extension DestinationSelectedTypeValue on DestinationSelectedType {
  String get value {
    switch (this) {
      case DestinationSelectedType.newCard:
        return 'new';
      case DestinationSelectedType.previousCard:
        return 'previous';
    }
  }
}
