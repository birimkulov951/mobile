import 'package:mobile_ultra/domain/payment/category_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';

abstract class MerchantRepository {
  bool get isPaymentDataLoaded;

  Future<void> setAllPaymentData(final Map<String, dynamic> data);

  Future<void> clearAllPaymentData();

  Future<void> setCategory(final List<dynamic> categoryList);

  Future<void> setMerchants(List<dynamic> merchantList);

  MerchantEntity? findMerchant(final int? merchantId);

  List<MerchantEntity> searchMerchantByName(String name, String lang);

  List<MerchantEntity> getMerchantList(int categoryId);

  List<MerchantEntity> getMerchantList2(List<int> categoryIds);

  List<MerchantEntity> getOtherMerchantList(List<int> categoryIds);

  Future<MerchantEntity?> getMerchantById(int id);

  Future<List<PaymentCategoryEntity>> getPaymentCategories();

  Future<List<MerchantEntity>> getMerchantByIds(
    List<int> ids, {
    bool sortByIds = true,
  });

  Future<List<MerchantEntity>> findMerchantsByName(String name);

  Future<List<MerchantEntity>> getLastSelectedMerchants();

  Future<void> saveLastSelectedMerchantId(int merchantId);

  Future<List<CategoryEntity>> getMerchantCategories();
}
