import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/phone_number_login_screen.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_arguments.dart';

class PhoneNumberLoginScreenRoute extends MaterialPageRoute {
  PhoneNumberLoginScreenRoute(PhoneNumberLoginScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(
            name: Tag,
            arguments: arguments,
          ),
        );

  static const Tag = '/phoneNumberLoginScreen';

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as PhoneNumberLoginScreenArguments;
    return PhoneNumberLoginScreen(arguments: arguments);
  }
}
