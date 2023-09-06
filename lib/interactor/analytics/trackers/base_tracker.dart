import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/interactor/analytics/analytics.dart';

/// Базовый класс отправки события
abstract class BaseTracker {
  /// Экземпляр класса аналитики
  @protected
  final Analytics analytics;

  BaseTracker(this.analytics);
}
