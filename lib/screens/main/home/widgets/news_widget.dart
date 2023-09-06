import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:ui_kit/ui_kit.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    required this.news,
    required this.dismissNotification,
    required this.onNotificationTap,
    super.key,
  });

  final EntityStateNotifier<List<NotificationEntity>?> news;
  final void Function(NotificationEntity notification) dismissNotification;
  final void Function(NotificationEntity notification) onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<List<NotificationEntity>?>(
      listenableEntityState: news,
      builder: (_, notifications) {
        if (notifications == null) {
          return const SizedBox();
        }

        return AnimatedContainer(
          padding: EdgeInsets.only(bottom: notifications.isEmpty ? 0 : 12),
          duration: const Duration(milliseconds: 300),
          child: notifications.isEmpty
              ? const SizedBox()
              : LayoutBuilder(
                  builder: (_, BoxConstraints constraints) {
                    return IntrinsicHeight(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (notifications.length > 1)
                            _backItem(
                              constraints,
                              _NewsItem(
                                notification: notifications[1],
                                dismissNotification: dismissNotification,
                                onNotificationTap: onNotificationTap,
                                backgroundColor: PfmColors.gray,
                              ),
                            ),
                          _frontItem(
                            constraints,
                            _NewsItem(
                              notification: notifications[0],
                              dismissNotification: dismissNotification,
                              onNotificationTap: onNotificationTap,
                              backgroundColor: BackgroundColors.news,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _backItem(BoxConstraints constraints, Widget child) {
    return Positioned(
      bottom: -8.0,
      child: Transform.scale(
        scale: 0.95,
        child: ConstrainedBox(
          constraints: constraints.copyWith(maxHeight: 64),
          child: child,
        ),
      ),
    );
  }

  Widget _frontItem(BoxConstraints constraints, Widget child) {
    return ConstrainedBox(
      constraints: constraints,
      child: child,
    );
  }
}

class _NewsItem extends StatelessWidget {
  const _NewsItem({
    required this.notification,
    required this.dismissNotification,
    required this.onNotificationTap,
    required this.backgroundColor,
  });

  final NotificationEntity notification;
  final void Function(NotificationEntity notification) dismissNotification;
  final void Function(NotificationEntity notification) onNotificationTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      onDismissed: (_) => dismissNotification(notification),
      child: GestureDetector(
        onTap: () => onNotificationTap(notification),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Typographies.textBold,
                    ),
                    if (notification.subtitle != null)
                      Flexible(
                        child: Column(
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              notification.subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Typographies.caption1,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                onPressed: () => dismissNotification(notification),
                constraints: BoxConstraints.tight(
                  const Size.square(24),
                ),
                splashRadius: 24.0,
                padding: EdgeInsets.zero,
                icon: IconContainer(
                  size: 24.0,
                  color: ControlColors.secondaryActive,
                  child: ActionIcons.close.copyWith(
                    width: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
