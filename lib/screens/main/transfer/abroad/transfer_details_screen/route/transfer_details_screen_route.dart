import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/transfer_details_screen.dart';

class TransferDetailsScreenRoute extends MaterialPageRoute {
  static const Tag = '/transferDetailsScreenRoute';

  TransferDetailsScreenRoute(TransferDetailsScreenRouteArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(name: Tag, arguments: arguments),
        );

  //for Navigator.push
  static TransferDetailsScreenRoute route(
      TransferDetailsScreenRouteArguments arguments) {
    return TransferDetailsScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferDetailsScreenRouteArguments;
    return TransferDetailsScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
