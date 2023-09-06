import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/main/payments/category/no_category.dart';
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/inject.dart';

class OtherServicesWidget extends StatefulWidget {
  final PaymentType type;

  OtherServicesWidget({PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY;

  @override
  State<StatefulWidget> createState() => OtherServicesWidgetState();
}

class OtherServicesWidgetState extends State<OtherServicesWidget> {
  @override
  Widget build(BuildContext context) => ListView(
        physics: BouncingScrollPhysics(),
        children: [
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(0),
              child: SvGraphics.icon(
                'ads',
                size: 28,
              ),
            ),
            title: 'ad',
            onTap: () => _onShowProvider(context, locale.getText('ad'), 78),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: SvGraphics.icon(
                'insurance',
                size: 40,
              ),
            ),
            title: 'insurance',
            onTap: () =>
                _onShowProvider(context, locale.getText('insurance'), 79),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: SvGraphics.icon(
                'imarket',
                size: 40,
              ),
            ),
            title: 'internet_market',
            onTap: () =>
                _onShowProvider(context, locale.getText('internet_market'), 80),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('charity'),
            ),
            title: 'charity',
            onTap: () =>
                _onShowProvider(context, locale.getText('charity'), 14),
          ),
          CategoryRowItem(
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: SvGraphics.icon('more'),
            ),
            title: 'other',
            onTap: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cotext) => NoCategoryWidget(
                            merchantRepository: inject(),
                            title: locale.getText('other'),
                            type: widget.type,
                          )));

              if (result != null) Navigator.pop(context, result);
            },
          ),
        ],
      );

  void _onShowProvider(
      BuildContext context, String title, int categoryId) async {
    final result = await Navigator.pushNamed(context, ProvidersWidget.Tag,
        arguments: [title, categoryId, widget.type]);

    if (result != null) Navigator.pop(context, result);
  }
}
