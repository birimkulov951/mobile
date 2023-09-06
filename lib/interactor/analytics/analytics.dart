import 'package:mobile_ultra/interactor/analytics/services/base_analytics_service.dart';
import 'package:mobile_ultra/utils/u.dart';

/// Класс для работы с аналитикой
class Analytics extends BaseAnalyticsService {
  /// Список сервисов аналитики
  final List<BaseAnalyticsService> _services;

  Analytics(this._services);

  /// Отправить событие в аналитику
  @override
  void logEvent(
    String name, {
    Map<String, dynamic>? params,
  }) {
    for (BaseAnalyticsService service in _services) {
      service.logEvent(
        name,
        params: params,
      );
      printLog(
        'Analytics service = ${service.runtimeType} logEvent\n'
        '---event = $name\n'
        '---params = $params',
      );
    }
  }

  @override
  void setUserId(String? id) {
    for (BaseAnalyticsService service in _services) {
      service.setUserId(id);
      printLog(
        'Analytics service = ${service.runtimeType} setUserId\n'
        '---userId = $id\n',
      );
    }
    super.setUserId(id);
  }
}
