class CardScanException implements Exception {
  CardScanException({this.message});

  final String? message;

  @override
  String toString() {
    return "CardScanException: $message";
  }
}
