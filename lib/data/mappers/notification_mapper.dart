import 'package:mobile_ultra/data/api/dto/responses/notification/notification_response.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';

extension NotificationEntityListExt on List<NotificationResponse> {
  List<NotificationEntity> toNotificationListEntity() =>
      map((notificationResponse) => notificationResponse.toEntity()).toList();
}

extension _NotificationEntityExt on NotificationResponse {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        date: date,
        title: title,
        logoUrl: logoUrl,
        message: message,
        subtitle: subtitle,
      );
}
