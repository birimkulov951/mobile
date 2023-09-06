import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/search.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class NoCategoryWidget extends StatefulWidget {
  NoCategoryWidget({
    required this.title,
    required this.merchantRepository,
    this.type = PaymentType.MAKE_PAY,
  });

  final String title;
  final PaymentType type;
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => NoCategoryWidgetState();
}

class NoCategoryWidgetState extends BaseInheritedTheme<NoCategoryWidget> {
  List<MerchantEntity> items = [];

  @override
  void onThemeChanged() {}

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () => readMerchants());
  }

  @override
  Widget get formWidget => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextLocale('other'),
          actions: <Widget>[
            SvGraphics.button(
              'search',
              size: 22,
              onPressed: () async {
                final result = await Navigator.pushNamed(
                    context, SearchProvidersWidget.Tag,
                    arguments: [
                      widget.title,
                      widget.type,
                    ]);

                if (result != null) Navigator.pop(context, result);
              },
            ),
          ],
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, position) => ProviderItem(
              merchant: items[position],
              onTap: (value) async {
                final result = await launchPaymentForm(
                  merchant: value,
                  type: widget.type,
                  title: widget.title,
                );

                if (result != null) Navigator.pop(context, result);
              }),
        ),
      );

  void readMerchants() async {
    items.addAll(
      widget.merchantRepository.getOtherMerchantList([
        1,
        3,
        4,
        6,
        9,
        11,
        14,
        15,
        16,
        17,
        70,
        71,
        73,
        74,
        75,
        76,
        77,
        78,
        79,
        80,
        81,
        101
      ]),
    );

    items.removeWhere((merchant) =>
        merchant.id == 3630 || merchant.id == 3769 || merchant.id == 4429);

    if (mounted) setState(() {});
  }
}
