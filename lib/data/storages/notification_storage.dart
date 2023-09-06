import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

const _readNotificationsKey = 'readNotifications';

@injectable
class NotificationStorage {
  const NotificationStorage(this._localStorage);

  final Box _localStorage;

  Set<int> get readNotificationIds {
    final List<int> ids = _localStorage.get(_readNotificationsKey) ?? [];
    return ids.toSet();
  }

  Future<void> saveNotificationAsRead(int notificationId) async {
    final ids = readNotificationIds;
    ids.add(notificationId);
    await _localStorage.put(_readNotificationsKey, ids.toList());
  }
}
