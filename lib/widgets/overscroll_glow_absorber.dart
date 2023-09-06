import 'package:flutter/material.dart';

/// Убирает material glow у списков при прокрутке
class OverscrollGlowAbsorber extends StatelessWidget {
  final Widget child;
  final bool Function(Notification)? _onNotification =
      (Notification notification) {
    if (notification is OverscrollIndicatorNotification) {
      notification.disallowIndicator();
    }

    return false;
  };

  OverscrollGlowAbsorber({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: child,
    );
  }
}
