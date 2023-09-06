/// Методы входа для события выполненного входа
enum LoginSuccessMethods {
  /// Через пин
  pin,

  /// Через биометрию
  biometry
}

extension LoginSuccessMethodsValue on LoginSuccessMethods {
  String get value {
    switch (this) {
      case LoginSuccessMethods.pin:
        return 'pin';
      case LoginSuccessMethods.biometry:
        return 'biometry';
    }
  }
}
