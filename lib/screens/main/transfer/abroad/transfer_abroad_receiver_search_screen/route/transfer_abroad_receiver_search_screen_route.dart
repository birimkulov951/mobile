import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/transfer_abroad_receiver_search_screen.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/arguments.dart';

class TransferAbroadReceiverSearchScreenRoute extends MaterialPageRoute {
  static const Tag = '/transferAbroadReceiverSearchScreen';

  TransferAbroadReceiverSearchScreenRoute(
      TransferAbroadReceiverSearchScreenRouteArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(
              name: Tag,
              arguments: arguments,
            ));

  //for Navigator.push
  static TransferAbroadReceiverSearchScreenRoute route(
      TransferAbroadReceiverSearchScreenRouteArguments arguments) {
    return TransferAbroadReceiverSearchScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferAbroadReceiverSearchScreenRouteArguments;
    return TransferAbroadReceiverSearchScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
