class CardNotActiveException implements Exception {
  CardNotActiveException({required this.title});

  final String title;
}
