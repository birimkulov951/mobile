import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/transfer_abroad_result_screen.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/arguments.dart';

class TransferAbroadResultScreenRoute extends MaterialPageRoute {
  TransferAbroadResultScreenRoute(TransferAbroadResultScreenArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(name: Tag, arguments: arguments));

  static const Tag = '/transfer_abroad_result_screen';

  static TransferAbroadResultScreenRoute route(
      TransferAbroadResultScreenArguments arguments) {
    return TransferAbroadResultScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferAbroadResultScreenArguments;
    return TransferAbroadResultScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
