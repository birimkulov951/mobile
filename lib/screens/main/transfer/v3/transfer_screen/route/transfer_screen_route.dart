import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/transfer_screen.dart';

class TransferScreenRoute extends MaterialPageRoute {
  TransferScreenRoute(TransferScreenArguments arguments)
      : super(
    builder: _buildScreen,
    settings: RouteSettings(name: Tag, arguments: arguments),
  );

  //todo Abdurahmon: remove _v3 after v2 is deleted
  static const Tag = '/transfer_screen_v3';

  //for Navigator.push
  static TransferScreenRoute route(TransferScreenArguments arguments) {
    return TransferScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as TransferScreenArguments;
    return TransferScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}