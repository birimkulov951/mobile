import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

/// Зарубежные сервисы
class ForeignServicesWidget extends StatelessWidget {
  final PaymentType type;

  ForeignServicesWidget({PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY;

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: SvGraphics.icon(
                'games',
                size: 40,
              ),
            ),
            title: 'games_and_social',
            onTap: () =>
                onShowProvider(context, locale.getText('games_and_social'), 75),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('globus'),
            ),
            title: 'foreign_operators',
            onTap: () => onShowProvider(
                context, locale.getText('foreign_operators'), 76),
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
