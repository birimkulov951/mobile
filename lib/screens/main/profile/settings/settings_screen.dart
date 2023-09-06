import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings_screen_wm.dart';

class SettingsScreen extends ElementaryWidget<ISettingsScreenWidgetModel> {
  const SettingsScreen({
    Key? key,
  }) : super(settingsScreenWidgetModelFactory, key: key);

  @override
  Widget build(ISettingsScreenWidgetModel wm) {
    return SettingsWidget(
      wm: wm,
    );
  }
}
