import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/currency_input_bottom_sheet.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/route/arguments.dart';

class CurrencyInputBottomSheetRoute {
  static const tag = '/currency_input_bottom_sheet';

  static Future<bool?> show({
    required BuildContext context,
    required CurrencyInputBottomSheetArguments arguments,
  }) async {
    final queryData = MediaQuery.of(context);
    final top = queryData.viewPadding.top;
    final height = queryData.size.height - top;

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: uikit.BackgroundColors.modal,
      barrierColor: uikit.BackgroundColors.dark,
      constraints: BoxConstraints(minHeight: height - 8, maxHeight: height - 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      routeSettings: RouteSettings(name: tag, arguments: arguments),
      builder: _build,
    );
  }

  static Widget _build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as CurrencyInputBottomSheetArguments;
    return CurrencyInputBottomSheet(arguments: arguments);
  }
}
