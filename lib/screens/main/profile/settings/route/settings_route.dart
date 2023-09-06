import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings_screen.dart';

class SettingsScreenRoute extends MaterialPageRoute {
  static const Tag = '/settingsScreen';

  SettingsScreenRoute()
      : super(
            builder: _buildScreen,
            settings: RouteSettings(
              name: Tag,
            ));

  static SettingsScreenRoute route() {
    return SettingsScreenRoute();
  }

  static Widget _buildScreen(BuildContext context) {
    return SettingsScreen();
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
