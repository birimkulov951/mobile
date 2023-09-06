//исключение должно выбрасываться если в Bill.responseJson содержится статус код больше 0
class StatusException implements Exception {
  StatusException(this.code, this.message);

  final int code;
  final String message;

  @override
  String toString() {
    return 'StatusException( code: $code; message: $message)';
  }
}

class StatusCodes {
  //Абонент не найден
  static const int subscriberNotFound = -666;

  //Неправильный код сообщения
  static const int invalidMessageCode = 1;

  //Ведутся профилактические работы
  static const int preventiveWork = 3;

  //Неправильное количество|Указан некоректный номер карты
  static const int wrongNumberAmount = 4;

  //Неправильная сумма
  static const int wrongAmount = 5;

  //Провайдер временно недоступен
  static const int providerTemporarilyUnavailable = 8;

  //Не найден номер клиента
  static const int clientNumberNotFound = 9;

  //Доступ запрещен. Возможно агент выключен
  static const int accessDenied = 10;

  //Отказано Провайдером
  static const int deniedByProvider = 11;

  //Юридическое лицо,запрещена оплата
  static const int paymentProhibited = 14;

  //Не хватает депозита
  static const int notEnoughDeposit = 15;

  //Проводится профилактика...
  static const int preventiveMaintenance = 17;

  //Идет тестирование...
  static const int testingInProgress = 18;

  //Вы не провели этот платеж
  static const int paymentNotMade = 20;

  //Provider return message
  static const int providerReturnMessage = 1010;
}
