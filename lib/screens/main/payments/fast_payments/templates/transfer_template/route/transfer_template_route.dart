import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template.dart';

import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';

class TransferTemplateRoute extends MaterialPageRoute {
  static const Tag = '/transfer_template';

  TransferTemplateRoute() : super(builder: _buildScreen);

  static MapEntry<String, WidgetBuilder> get mapEntry {
    return MapEntry<String, WidgetBuilder>(Tag, _buildScreen);
  }

  static Widget _buildScreen(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferTemplateRouteArguments;
    return TransferTemplate(arguments: arguments);
  }
}
