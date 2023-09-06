import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/storages/database.dart';
import 'package:mobile_ultra/data/storages/merchants_storage.dart';
import 'package:mobile_ultra/data/storages/payment_data_storage.dart';
import 'package:mobile_ultra/domain/payment/category_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/utils/const.dart';

@Singleton(as: MerchantRepository)
class MerchantRepositoryImpl implements MerchantRepository {
  MerchantRepositoryImpl({
    required this.muDatabase,
    required this.merchantsStorage,
    required this.paymentDataStorage,
  });

  final MUDatabase muDatabase;
  final MerchantsStorage merchantsStorage;
  final PaymentDataStorage paymentDataStorage;

  @override
  bool get isPaymentDataLoaded => paymentDataStorage.isPaymentDataLoaded;

  @override
  Future<void> setAllPaymentData(final Map<String, dynamic> data) async {
    await paymentDataStorage.setAllPaymentData(data);
  }

  @override
  Future<void> clearAllPaymentData() async {
    await paymentDataStorage.clearAllPaymentData();
  }

  @override
  Future<void> setCategory(final List<dynamic> categoryList) async {
    await paymentDataStorage.setCategory(categoryList);
  }

  @override
  Future<void> setMerchants(final List<dynamic> merchantList) async {
    await paymentDataStorage.setMerchants(merchantList);
  }

  @override
  MerchantEntity? findMerchant(final int? merchantId) {
    return paymentDataStorage.findMerchant(merchantId);
  }

  @override
  List<MerchantEntity> getMerchantList(final int categoryId) {
    return paymentDataStorage.getMerchantList(categoryId);
  }

  @override
  List<MerchantEntity> getMerchantList2(final List<int> categoryIds) {
    return paymentDataStorage.getMerchantList2(categoryIds);
  }

  @override
  List<MerchantEntity> getOtherMerchantList(final List<int> categoryIds) {
    return paymentDataStorage.getOtherMerchantList(categoryIds);
  }

  @override
  List<MerchantEntity> searchMerchantByName(
    final String name,
    final String lang,
  ) {
    return paymentDataStorage.searchMerchantByName(name, lang);
  }

  @override
  Future<List<PaymentCategoryEntity>> getPaymentCategories() async {
    return Const.paymentCatList;
  }

  @override
  Future<List<CategoryEntity>> getMerchantCategories() async {
    return await paymentDataStorage.getCategories();
  }

  @override
  Future<List<MerchantEntity>> getMerchantByIds(
    List<int> ids, {
    bool sortByIds = true,
  }) async {
    final list = await paymentDataStorage.getMerchantListByIds(ids);

    if (sortByIds) {
      final List<MerchantEntity> sortedByIdsList = [];
      for (final id in ids) {
        final merchant = list.firstWhereOrNull((e) => e.id == id);
        if (merchant != null) {
          sortedByIdsList.add(merchant);
        }
      }
      return sortedByIdsList;
    }
    return list;
  }

  @override
  Future<List<MerchantEntity>> findMerchantsByName(String name) async {
    return await paymentDataStorage.searchMerchantByName(name, locale.prefix);
  }

  @override
  Future<List<MerchantEntity>> getLastSelectedMerchants() async {
    final ids = await merchantsStorage.restoreLastSelectedMerchantIds();
    if (ids.isEmpty) {
      return [];
    }
    return await getMerchantByIds(ids);
  }

  @override
  Future<void> saveLastSelectedMerchantId(int merchantId) async {
    await merchantsStorage.storeLastSelectedMerchantId(merchantId);
  }

  @override
  Future<MerchantEntity?> getMerchantById(int id) async {
    return await paymentDataStorage.findMerchant(id);
  }
}
