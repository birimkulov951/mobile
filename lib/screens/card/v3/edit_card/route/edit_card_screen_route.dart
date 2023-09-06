import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/edit_card_screen.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/route/arguments.dart';

class EditCardScreenRoute extends MaterialPageRoute {
  EditCardScreenRoute(EditCardScreenArguments arguments)
      : super(
          builder: _buildScreen,
          settings: RouteSettings(name: Tag, arguments: arguments),
        );

  static const Tag = '/edit_card_screen';

  //for Navigator.push
  static EditCardScreenRoute route(EditCardScreenArguments arguments) {
    return EditCardScreenRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as EditCardScreenArguments;
    return EditCardScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return const MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
