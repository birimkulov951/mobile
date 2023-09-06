import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/notification_api.dart';
import 'package:mobile_ultra/data/mappers/notification_mapper.dart';
import 'package:mobile_ultra/data/storages/notification_storage.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/repositories/notification_repository.dart';

@Singleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(
    this._notificationApi,
    this._notificationStorage,
  );

  final NotificationApi _notificationApi;
  final NotificationStorage _notificationStorage;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await _notificationApi.getNotifications();
    return response.toNotificationListEntity();
  }

  @override
  Future<void> saveNotificationAsRead(int notificationId) async {
    await _notificationStorage.saveNotificationAsRead(notificationId);
  }

  @override
  Set<int> get readNotificationIds => _notificationStorage.readNotificationIds;

  @override
  Future<List<NotificationEntity>> getUnreadNotifications(
    List<int> readNotificationIds,
  ) async {
    final response =
        await _notificationApi.getUnreadNotifications(readNotificationIds);
    return response.toNotificationListEntity();
  }
}
