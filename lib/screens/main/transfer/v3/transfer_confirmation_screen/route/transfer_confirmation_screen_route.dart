import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/transfer_confirmation_screen.dart';

class TransferConfirmationScreenRoute extends MaterialPageRoute {
  TransferConfirmationScreenRoute(TransferConfirmationScreenArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(name: Tag, arguments: arguments));

  static const Tag = '/transfer_confirmation_screen';

  //for Navigator.push
  static TransferConfirmationScreenRoute route(
      TransferConfirmationScreenArguments arguments) {
    return TransferConfirmationScreenRoute(arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return const MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferConfirmationScreenArguments;
    return TransferConfirmationScreen(arguments: arguments);
  }
}
