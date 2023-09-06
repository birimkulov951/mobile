/// Интерактор авторизации и регистрации
/// TODO в будущем перевести бизнес логику авторизации и регистрации сюда
class AuthInteractor {
  /// TODO перевести с синглтона на GetIt
  static late final AuthInteractor instance = AuthInteractor._();

  factory AuthInteractor() => instance;

  AuthInteractor._();

  /// TODO в будущем должен быть только геттер,
  /// логика определения инкапсулирована здесь
  ///
  /// true - аккаунт в стадии регистрации
  /// false - авторизации
  bool isRegistration = false;
}
