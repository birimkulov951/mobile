import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart' show locale, db;
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';

/// Мобильные операторы и ГТС
class ConnectionWidget extends StatelessWidget {
  final PaymentType type;
  final MerchantRepository merchantRepository;
  final List<MerchantEntity> merchants;

  ConnectionWidget(this.merchantRepository, {PaymentType? type})
      : type = type ?? PaymentType.MAKE_PAY,
        merchants = merchantRepository.getMerchantList(1);

  @override
  Widget build(BuildContext context) {
    var gts = merchants.firstWhereOrNull((element) => element.id == 3630);
    merchants.removeWhere((element) => element.id == 3630);
    if (gts != null) {
      merchants.add(gts);
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: merchants.length,
      itemBuilder: (ctx, index) => ProviderItem(
        merchant: merchants[index],
        onTap: (merchant) => _openProvider(context, merchant),
      ),
    );
  }

  void _openProvider(BuildContext context, MerchantEntity? merchant) async {
    final result = await launchPaymentForm(
      context: context,
      merchant: merchant,
      title: locale.getText('mobile'),
      type: type,
    );
    if (result != null) Navigator.pop(context, result);
  }
}
