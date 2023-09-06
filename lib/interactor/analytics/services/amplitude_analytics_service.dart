import 'package:amplitude_flutter/amplitude.dart';
import 'package:mobile_ultra/interactor/analytics/services/base_analytics_service.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';

/// Класс для работы с аналитикой Amplitude
class AmplitudeAnalyticsService extends BaseAnalyticsService {
  final RemoteConfigRepository _remoteConfigRepository;

  /// Экземпляр аналитики Amplitude
  static final _instance = Amplitude.getInstance();

  AmplitudeAnalyticsService(this._remoteConfigRepository);

  /// Отправить событие в Amplitude
  @override
  void logEvent(
    String name, {
    Map<String, dynamic>? params,
  }) async {
    final remoteConfig = await _remoteConfigRepository.getRemoteConfig();
    final amplitudeEvents = remoteConfig.analyticsAmplitudeEventsList;
    if (amplitudeEvents[name] == false) {
      return;
    }
    _instance.logEvent(
      name,
      eventProperties: params ?? BaseAnalyticsService.defaultParams,
    );
  }

  @override
  void setUserId(String? id) {
    super.setUserId(id);
    _instance.setUserId(id);
  }
}
