import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/transfer_abroad_confirmation_screen.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/arguments.dart';

class TransferAbroadConfirmationScreenRoute extends MaterialPageRoute {
  TransferAbroadConfirmationScreenRoute(
      TransferAbroadConfirmationScreenRouteArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(name: Tag, arguments: arguments));

  static const Tag = '/transfer_abroad_confirmation_screen';

  //for Navigator.push
  static TransferAbroadConfirmationScreenRoute route(
      TransferAbroadConfirmationScreenRouteArguments arguments) {
    return TransferAbroadConfirmationScreenRoute(arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferAbroadConfirmationScreenRouteArguments;
    return TransferAbroadConfirmationScreen(arguments: arguments);
  }
}
