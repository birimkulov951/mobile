import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart'
    show appTheme, pref, screenHeight, statusBarHeight;
import 'package:mobile_ultra/utils/my_theme.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_wrapper.dart';

abstract class BaseInheritedTheme<T extends StatefulWidget> extends State<T> {
  Widget get formWidget;

  /// Screen height excludes status bar and tool bar.
  double height = 0;

  /// Key 4 top container to get rendered form size
  GlobalKey topContainerKey = GlobalKey();

  /// Key 4 bottom container to get rendered form size
  GlobalKey bottomContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      height = screenHeight -
          (statusBarHeight +
              kToolbarHeight +
              MediaQuery.of(context).viewPadding.bottom);
      _calcFreeSpace(true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calcFreeSpace(false);
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: appTheme,
        child: GestureDetector(
          child: SafeArea(
            top: false,
            bottom: false,
            child: LocaleWrapper(builder: (_) => formWidget),
          ),
          onTap: () {
            FocusScope.of(context).focusedChild?.unfocus();
          },
        ),
      );

  void changeTheme(Brightness brightness) {
    appTheme = MyTheme.switchTheme(brightness);
    pref?.setCurrentTheme(brightness.index);
    switchColors(brightness);
    onThemeChanged();
  }

  void _calcFreeSpace(bool init) {
    if (topContainerKey.currentContext != null ||
        bottomContainerKey.currentContext != null) {
      final topSize = topContainerKey.currentContext != null
          ? (topContainerKey.currentContext?.findRenderObject() as RenderBox?)
          ?.size
          : Size(0, 0);

      final bottomSize = bottomContainerKey.currentContext != null
          ? (bottomContainerKey.currentContext?.findRenderObject() as RenderBox?)
          ?.size
          : Size(0, 0);

      if (topSize != null && bottomSize != null) {
        onGetFreeSpace(
            init: init, freeSpace: height - (topSize.height + bottomSize.height));
      }
    }
  }

  void onGetFreeSpace({
    bool init = true,
    double freeSpace = 0,
  }) {}

  void onThemeChanged() {}
}
