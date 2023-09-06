class CardNotFoundException implements Exception {
  CardNotFoundException({required this.title});

  final String title;
}
