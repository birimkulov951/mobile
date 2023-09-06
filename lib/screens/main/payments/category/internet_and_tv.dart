import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

/// Интернет и ТВ
class InternetAndTVWidget extends StatelessWidget {
  final PaymentType type;

  InternetAndTVWidget({PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY;

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('wifi'),
            ),
            title: 'internet',
            onTap: () => onShowProvider(context, locale.getText('internet'), 3),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('tv'),
            ),
            title: 'tv',
            onTap: () => onShowProvider(context, locale.getText('tv'), 9),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('place'),
            ),
            title: 'ip_telephony',
            onTap: () =>
                onShowProvider(context, locale.getText('ip_telephony'), 4),
          ),
        ],
      );

  void onShowProvider(
      BuildContext context, String title, int categoryId) async {
    final result = await Navigator.pushNamed(context, ProvidersWidget.Tag,
        arguments: [title, categoryId, type]);

    if (result != null) Navigator.pop(context, result);
  }
}
