import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/screens/main/home/notification/notification_screen.dart';
import 'package:mobile_ultra/screens/main/home/notification/notification_screen_model.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class INotificationScreenWidgetModel extends IWidgetModel {
  abstract final EntityStateNotifier<List<NotificationEntity>> notificationList;

  Future<void> getNotifications();
}

class NotificationScreenWidgetModel
    extends WidgetModel<NotificationScreen, NotificationScreenModel>
    implements INotificationScreenWidgetModel {
  NotificationScreenWidgetModel(super.model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    getNotifications();
  }

  @override
  late final EntityStateNotifier<List<NotificationEntity>> notificationList =
      EntityStateNotifier<List<NotificationEntity>>();

  @override
  Future<void> getNotifications() async {
    notificationList.loading(notificationList.value?.data);
    final notificationsList = await model.getNotifications();
    notificationList.content(notificationsList);
  }
}

NotificationScreenWidgetModel notificationsScreenWidgetModelFactory(
  BuildContext context,
) =>
    NotificationScreenWidgetModel(
      NotificationScreenModel(
        inject(),
      ),
    );
