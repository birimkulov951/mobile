import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobile_ultra/interactor/analytics/services/base_analytics_service.dart';

/// Класс для работы с аналитикой Firebase
class FirebaseAnalyticsService extends BaseAnalyticsService {
  /// Экземпляр аналитики Firebase
  static final _instance = FirebaseAnalytics.instance;

  /// Отправить событие в Firebase
  @override
  void logEvent(
    String name, {
    Map<String, dynamic>? params,
  }) {
    _instance.logEvent(
      name: name,
      parameters: params ?? BaseAnalyticsService.defaultParams,
    );
  }

  @override
  void setUserId(String? id) {
    super.setUserId(id);
    _instance.setUserId(id: id);
    _instance.setUserProperty(name: 'user_id', value: id);
  }
}
