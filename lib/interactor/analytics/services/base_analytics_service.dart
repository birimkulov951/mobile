/// Базовый класс, предоставляющий общий интерфейс для сервисов аналитики.
///
/// Для каждой из поддерживаемых сервисов аналитики должен быть реализован
/// наследник данного класса
abstract class BaseAnalyticsService {
  static const defaultParams = <String, String>{};

  /// Отправить событие в сервис аналитики
  /// [name] наименование события
  /// [params] атрибуты события
  void logEvent(
    String name, {
    Map<String, dynamic>? params,
  });

  /// Установить ид пользователя
  /// [id] ид пользователя
  void setUserId(String? id) {}
}
