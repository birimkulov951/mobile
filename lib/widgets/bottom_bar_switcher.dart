import 'package:flutter/material.dart';

class BottomBarSwitcher extends InheritedWidget {
  BottomBarSwitcher({
    required super.child,
    required this.showBottomBar,
    required this.switchBottomBar,
  });

  final bool showBottomBar;
  final void Function(bool) switchBottomBar;

  static BottomBarSwitcher of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomBarSwitcher>()!;
  }

  @override
  bool updateShouldNotify(covariant BottomBarSwitcher oldWidget) {
    return this.showBottomBar != oldWidget.showBottomBar;
  }
}
