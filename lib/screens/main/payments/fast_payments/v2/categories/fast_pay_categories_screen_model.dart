import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';

class FastPayCategoriesScreenModel extends ElementaryModel {
  FastPayCategoriesScreenModel(this._merchantRepository);

  final MerchantRepository _merchantRepository;

  MerchantEntity? findMerchant(final int merchantId) {
    return _merchantRepository.findMerchant(merchantId);
  }
}
