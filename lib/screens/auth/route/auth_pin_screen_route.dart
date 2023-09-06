import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/auth/auth_pin_screen.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_arguments.dart';

class AuthPinScreenRoute extends MaterialPageRoute {
  AuthPinScreenRoute(AuthPinScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(
            name: Tag,
            arguments: arguments,
          ),
        );

  static const Tag = '/authPinScreen';

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as AuthPinScreenArguments;
    return AuthPinScreen(arguments: arguments);
  }
}
