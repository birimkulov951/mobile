import 'package:mobile_ultra/domain/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();

  Future<List<NotificationEntity>> getUnreadNotifications(
    List<int> readNotificationIds,
  );

  Set<int> get readNotificationIds;

  Future<void> saveNotificationAsRead(int notificationId);
}
