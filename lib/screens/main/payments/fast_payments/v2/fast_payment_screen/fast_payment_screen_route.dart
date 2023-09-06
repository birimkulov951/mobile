import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen.dart';

class FastPaymentScreenRoute extends MaterialPageRoute {
  static const Tag = '/fastPaymentScreen';

  FastPaymentScreenRoute() : super(builder: _buildScreen);

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    return const FastPaymentScreen();
  }
}
