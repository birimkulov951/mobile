import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:mobile_ultra/interactor/analytics/services/base_analytics_service.dart';

/// Класс для работы с аналитикой AppMetrica
class AppMetricaAnalyticsService extends BaseAnalyticsService {
  /// Отправить событие в сервис аналитики
  @override
  void logEvent(
    String name, {
    Map<String, dynamic>? params = BaseAnalyticsService.defaultParams,
  }) {
    if (params != null) {
      AppMetrica.reportEventWithJson(name, jsonEncode(params));
    } else {
      AppMetrica.reportEvent(name);
    }
  }

  /// Установить id пользователя
  @override
  void setUserId(String? id) {
    AppMetrica.setUserProfileID(id);
  }
}
