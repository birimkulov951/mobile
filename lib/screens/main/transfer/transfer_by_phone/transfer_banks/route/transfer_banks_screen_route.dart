import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/transfer_banks_screen.dart';

class TransferBanksScreenRoute extends MaterialPageRoute {
  static const Tag = '/transferBanksScreen';

  TransferBanksScreenRoute() : super(builder: _buildScreen);

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferBanksScreenRouteArguments;
    return TransferBanksScreen(arguments: arguments);
  }
}
