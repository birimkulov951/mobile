import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/screens/main/home/notification/notification_screen_wm.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/arguments.dart';
import 'package:mobile_ultra/screens/main/home/notification/widgets/notification_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/home/notification/widgets/notification_item_widget.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class NotificationScreen
    extends ElementaryWidget<INotificationScreenWidgetModel> {
  const NotificationScreen({
    required this.arguments,
    Key? key,
  }) : super(notificationsScreenWidgetModelFactory, key: key);

  final NotificationScreenArguments arguments;

  @override
  Widget build(INotificationScreenWidgetModel wm) {
    return RefreshIndicator(
      color: ColorNode.Green,
      onRefresh: () => wm.getNotifications(),
      child: Scaffold(
        appBar: PynetAppBar('notification'),
        body: EntityStateNotifierBuilder<List<NotificationEntity>>(
          listenableEntityState: wm.notificationList,
          loadingBuilder: (context, data) {
            return data == null
                ? LoadingWidget(
                    showLoading: true,
                    withProgress: true,
                  )
                : _notificationsList(data);
          },
          builder: (context, data) {
            if (data == null || data.isEmpty) {
              return const SizedBox.shrink();
            }
            return _notificationsList(data);
          },
        ),
      ),
    );
  }

  ListView _notificationsList(List<NotificationEntity> data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return NotificationItemWidget(
          model: data[index],
          onTap: () {
            NotificationBottomSheet.show(
              context,
              data: data[index],
            );
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }
}
