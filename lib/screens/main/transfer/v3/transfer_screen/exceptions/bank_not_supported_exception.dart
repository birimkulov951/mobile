class BankNotSupportedException implements Exception {
  BankNotSupportedException({required this.title});

  final String title;
}
