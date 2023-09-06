import 'package:flutter/material.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart' show locale, db;
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

/// Транспорт
class TransportWidget extends StatelessWidget {
  final PaymentType type;
  final MerchantRepository merchantRepository;

  TransportWidget(this.merchantRepository, {PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY;

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('taxi'),
            ),
            title: 'taxi_license',
            onTap: () =>
                onShowProvider(context, locale.getText('taxi_license'), 71),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('taxi'),
            ),
            title: 'taxi_dept',
            onTap: () =>
                onShowProvider(context, locale.getText('taxi_dept'), 11),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('report'),
            ),
            title: 'air_tickets',
            onTap: () =>
                onShowProvider(context, locale.getText('air_tickets'), 73),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: SvGraphics.icon('transport', size: 40),
            ),
            title: 'intercity_transport',
            onTap: () => onShowProvider(
                context, locale.getText('intercity_transport'), 74),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: SvGraphics.icon('atto', size: 40),
            ),
            single: true,
            title: 'atto_replenishment',
            onTap: () async {
              final result = await launchPaymentForm(
                  context: context,
                  merchant: merchantRepository.findMerchant(3769),
                  type: type,
                  title: locale.getText('transport'));
              if (result != null) Navigator.pop(context, result);
            },
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
