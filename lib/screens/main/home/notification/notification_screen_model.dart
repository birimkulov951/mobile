import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/repositories/notification_repository.dart';

class NotificationScreenModel extends ElementaryModel {
  NotificationScreenModel(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<List<NotificationEntity>> getNotifications() async {
    try {
      return await _notificationRepository.getNotifications();
    } on Object catch (error) {
      handleError(error);
      return [];
    }
  }
}
