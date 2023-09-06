import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/utils/u.dart';

typedef NotificationRawData = Map<String, dynamic>;

/// Интерактор уведомлений
class PushNotificationsInteractor {
  /// TODO перевести с синглтона на GetIt
  static late final PushNotificationsInteractor instance =
      PushNotificationsInteractor._();

  late final _messaging = FirebaseMessaging.instance;

  ValueChanged<NotificationRawData>? _onLaunch;
  ValueChanged<NotificationRawData>? _onResume;
  AsyncValueSetter<RemoteMessage> _onBackgroundMessage =
      (RemoteMessage) async {};

  StreamSubscription? _backgroundMessageSubscription;

  factory PushNotificationsInteractor() => instance;

  PushNotificationsInteractor._();

  // onLaunch: (Map<String, dynamic> data) async => pushData = data,
  // onResume: (Map<String, dynamic> data) async => pushData = data,
  // onBackgroundMessage:
  // Platform.isAndroid ? onHandleBackgroundMessage : null);
  void configure({
    ValueChanged<NotificationRawData>? onLaunch,
    ValueChanged<NotificationRawData>? onResume,
    required AsyncValueSetter<RemoteMessage> onBackgroundMessage,
  }) {
    _onLaunch = onLaunch;
    _onResume = onResume;
    _onBackgroundMessage = onBackgroundMessage;

    _initStartApp();
    _initResumeApp();
    _initBackground();
  }

  /// Запросить разрешение на показ уведомлений
  Future<void> requestPermission() async {
    try {
      await _messaging.requestPermission();
    } on Object catch (e) {
      printLog(e);
    }
  }

  void close() {
    _backgroundMessageSubscription?.cancel();
  }

  void dispose() {
    close();
  }

  /// Запуск с уведомления закрытого приложения
  Future<void> _initStartApp() async {
    try {
      /// Если initialMessage != null
      /// значит приложение было запущено с уведомления
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      printLog('FCM initialMessage:\n$initialMessage');

      if (initialMessage == null) {
        return;
      }

      _onLaunch?.call(initialMessage.data);
    } on Object catch (e) {
      printLog(e.toString());
    }
  }

  /// Запуск с уведомления когда приложение было раскрыто из фона
  void _initResumeApp() {
    _backgroundMessageSubscription?.cancel();
    _backgroundMessageSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
      _handleResume,
    );
  }

  /// Запуск слушателя уведомления в фоне
  void _initBackground() {
    if (!Platform.isAndroid) {
      return;
    }

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  /// Обработчик открытия уведомления уведоления свернутого приложения
  /// Предоставляемых FCM
  void _handleResume(RemoteMessage message) {
    printLog('FCM onMessageOpenedApp:\n$message');

    _onResume?.call(message.data);
  }

  /// Обработчик фоновых уведолений
  /// Предоставляемых FCM

}
