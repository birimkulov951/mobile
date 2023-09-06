import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart' show locale, db;
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

/// Коммунальные платежи. Статичная форма.
class CommunalPaymentsWidget extends StatelessWidget {
  CommunalPaymentsWidget(this.merchantRepository, {PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY,
        merchants = merchantRepository.getMerchantList(6);

  final PaymentType type;
  final MerchantRepository merchantRepository;
  final List<MerchantEntity> merchants;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Column(
              children: List.generate(
                merchants.length,
                (index) => ProviderItem(
                  merchant: merchants[index],
                  onTap: (merchant) => _openProvider(context, merchant),
                ),
              ),
            ),
            CategoryRowItem(
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: SvGraphics.icon('home'),
              ),
              leadingSize: 50,
              title: 'tchsj',
              onTap: () =>
                  _onShowProvider(context, locale.getText('tchsj'), 70),
            ),
          ],
        ),
      );

  void _openProvider(BuildContext context, MerchantEntity? merchant) async {
    final result = await launchPaymentForm(
      context: context,
      merchant: merchant,
      title: locale.getText('communal_payments'),
      type: type,
    );

    if (result != null) Navigator.pop(context, result);
  }

  void _onShowProvider(
      BuildContext context, String title, int categoryId) async {
    final result = await Navigator.pushNamed(context, ProvidersWidget.Tag,
        arguments: [title, categoryId, type]);

    if (result != null) Navigator.pop(context, result);
  }
}
