import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/fast_payment_failed_screen.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/route/arguments.dart';

class FastPaymentFailedRoute extends MaterialPageRoute {
  FastPaymentFailedRoute(FastPaymentFailedScreenArguments arguments)
      : super(
            builder: _buildScreen,
            settings: RouteSettings(name: Tag, arguments: arguments));

  static const Tag = '/fast_payment_failed_screen';

  static FastPaymentFailedRoute route(
      FastPaymentFailedScreenArguments arguments) {
    return FastPaymentFailedRoute(arguments);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as FastPaymentFailedScreenArguments;
    return FastPaymentFailedScreen(arguments: arguments);
  }

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }
}
