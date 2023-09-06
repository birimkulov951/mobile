import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/home/notification/notification_screen.dart';

import 'package:mobile_ultra/screens/main/home/notification/route/arguments.dart';

class NotificationScreenRoute extends MaterialPageRoute {
  NotificationScreenRoute(NotificationScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(
            name: Tag,
            arguments: arguments,
          ),
        );

  static const Tag = '/notificationScreen';

  static NotificationScreenRoute route(NotificationScreenArguments arguments) {
    return NotificationScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as NotificationScreenArguments;
    return NotificationScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return const MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
