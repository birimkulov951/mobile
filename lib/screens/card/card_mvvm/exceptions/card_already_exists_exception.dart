class CardAlreadyExistsException implements Exception {
  CardAlreadyExistsException({required this.title});

  final String title;
}
