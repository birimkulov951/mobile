import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/domain/payment/category_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';
import 'package:mobile_ultra/repositories/favorite_repository.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/repositories/payment_repository.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/favorite/favorite_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';

class PaymentsScreenModel extends ElementaryModel
    with SystemModelMixin, RemoteConfigModelMixin, FavoriteModelMixin {
  PaymentsScreenModel({
    required SystemRepository systemRepository,
    required this.transferRepository,
    required RemoteConfigRepository remoteConfigRepository,
    required MerchantRepository merchantRepository,
    required FavoriteRepository favoriteRepository,
  }) {
    this.systemRepository = systemRepository;
    this.remoteConfigRepository = remoteConfigRepository;
    this.favoriteRepository = favoriteRepository;
    this.merchantRepository=merchantRepository;
  }

  @protected
  final PaymentRepository transferRepository;


  Future<void> saveLastPickedCard({required int? pickedCardId}) async {
    await transferRepository.saveLastPickedCardId(pickedCardId: pickedCardId);
  }

  Future<int?> getLastPickedCardId() async {
    return await transferRepository.getLastPickedCardId();
  }

  Future<List<MerchantEntity>?> fetchPopularMerchants() async {
    try {
      final remoteConfig = await remoteConfigRepository.getRemoteConfig();
      final popularMerchantIds = remoteConfig.popularMerchants;
      return await merchantRepository.getMerchantByIds(popularMerchantIds);
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }

  Future<List<MerchantEntity>?> findMerchants(String text) async {
    try {
      return await merchantRepository.findMerchantsByName(text);
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }

  Future<List<MerchantEntity>?> fetchLastSelectedMerchants() async {
    try {
      return await merchantRepository.getLastSelectedMerchants();
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }

  Future<void> saveLastSelectedMerchantId(int merchantId) async {
    try {
      await merchantRepository.saveLastSelectedMerchantId(merchantId);
    } on Object catch (error) {
      handleError(error);
    }
  }

  Future<List<PaymentCategoryEntity>?> fetchPaymentCategories() async {
    try {
      return await merchantRepository.getPaymentCategories();
    } on Object catch (error) {
      handleError(error);
    }
  }

  Future<List<CategoryEntity>?> fetchMerchantCategories() async {
    try {
      return await merchantRepository.getMerchantCategories();
    } on Object catch (error) {
      handleError(error);
    }
  }
}
