import 'dart:async';

import 'package:flutter/services.dart';

enum AppUpdateStatus {
  NO_UPDATE,
  UPDATE_AVAILABLE,
  UPDATING,
  UPDATE_CANCELED,
}

class MC {
  final MethodChannel _methodChannel = MethodChannel('app.paynet.uz.mc');

  /// Проверка наличия обновления. Реализовано пока только для андроида.
  void checkAppUpdate({
    Function(AppUpdateStatus)? onUpdateAvailableAndConfirm,
  }) {
    _methodChannel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'going_to_upd':
          return onUpdateAvailableAndConfirm?.call(AppUpdateStatus.values
              .firstWhere((status) => status.index == call.arguments,
                  orElse: () => AppUpdateStatus.NO_UPDATE));
        default:
          return Future<String>.value('Unknown event listener');
      }
    });
    _methodChannel.invokeMethod('check_update');
  }

  void openAppStore() => _methodChannel.invokeMethod('open_app_store');
}
