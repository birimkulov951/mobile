import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/card_addition_screen.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';

class CardAdditionScreenRoute extends MaterialPageRoute {
  CardAdditionScreenRoute(CardAdditionScreenRouteArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(name: Tag, arguments: arguments));

  static const Tag = '/cardAdditionScreen';

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return const MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as CardAdditionScreenRouteArguments;
    return CardAdditionScreen(arguments: arguments);
  }
}
