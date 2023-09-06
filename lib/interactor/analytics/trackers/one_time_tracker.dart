import 'package:mobile_ultra/interactor/analytics/trackers/base_tracker.dart';

/// Трекер одноразовых событий
class OneTimeTracker extends BaseTracker {
  OneTimeTracker(super.analyticsService);

  /// Отправить количество избранных шаблонов
  void trackFavoritesQuantity(int count) {
    analytics.logEvent(
      'favs_list',
      params: {'count': count},
    );
  }

  /// Отправить количество моих счетов
  void trackMyAccountsQuantity(int count) {
    analytics.logEvent(
      'bills_list',
      params: {'count': count},
    );
  }

  /// Отправить количество привязанных карт
  void trackAttachedCardsQuantity(int count) {
    analytics.logEvent(
      'cards_list',
      params: {'count': count},
    );
  }
}
