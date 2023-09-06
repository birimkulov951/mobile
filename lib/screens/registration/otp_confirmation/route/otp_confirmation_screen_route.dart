import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/otp_confirmation_screen.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_arguments.dart';

class OtpConfirmationScreenRoute extends MaterialPageRoute {
  OtpConfirmationScreenRoute(OtpConfirmationScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(
            name: Tag,
            arguments: arguments,
          ),
        );

  static const Tag = '/otpConfirmationScreen';

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as OtpConfirmationScreenArguments;
    return OtpConfirmationScreen(arguments: arguments);
  }
}
