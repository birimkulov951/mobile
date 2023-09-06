import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/payment/category_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/payment/merchant_response.dart';
import 'package:mobile_ultra/data/hive/payment/category_hive_object.dart';
import 'package:mobile_ultra/data/hive/payment/merchant_hive_object.dart';
import 'package:mobile_ultra/data/mappers/payment/category_mapper.dart';
import 'package:mobile_ultra/data/mappers/payment/merchant_mapper.dart';
import 'package:mobile_ultra/domain/payment/category_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/translit.dart';

@injectable
class PaymentDataStorage {
  final Box<CategoryHiveObject> _categories =
      Hive.box<CategoryHiveObject>('pynet_payment_categories');
  final Box<MerchantHiveObject> _merchants =
      Hive.box<MerchantHiveObject>('pynet_merchants');

  /// Checks, if payment data is loaded.
  bool get isPaymentDataLoaded => _categories.values.isNotEmpty;

  Future<void> setAllPaymentData(final Map<String, dynamic> data) async {
    await setCategory(data['categories']);
    await setMerchants(data['merchants']);
  }

  Future<void> clearAllPaymentData() async {
    await _categories.clear();
    await _merchants.clear();
  }

  /// Stores categories.
  Future<void> setCategory(final List<dynamic> categoryList) async {
    if (categoryList.isNotEmpty) {
      final List<CategoryResponse> categories =
          categoryList.map((e) => CategoryResponse.fromJson(e)).toList();

      final List<CategoryHiveObject> objects =
          categories.map((e) => e.toHiveObject()).toList();

      await _categories.clear();

      await _categories.addAll(objects);
    }
  }

  Future<List<CategoryEntity>> getCategories() async {
    return _categories.values.map((e) => e.toEntity()).toList();
  }

  /// Stores merchants.
  Future<void> setMerchants(List<dynamic> merchantList) async {
    if (merchantList.isNotEmpty) {
      final List<MerchantResponse> merchants =
          merchantList.map((e) => MerchantResponse.fromJson(e)).toList();

      await _merchants.clear();

      for (final item in merchants) {
        if (item.id != 4250) {
          await _merchants.add(item.toHiveObject());
        }
      }
    }
  }

  /// Finds merchant by ID.
  MerchantEntity? findMerchant(final int? merchantId) {
    final MerchantHiveObject? object = _merchants.values
        .singleWhereOrNull((merchant) => merchant.id == merchantId);

    return object?.toEntity();
  }

  /// Finds merchant by name.
  List<MerchantEntity> searchMerchantByName(
    String name,
    String lang,
  ) {
    final List<String> transcriptions = [name];
    transcriptions.addAll(TranslitUtils.getTranslits(name));

    final Set<MerchantHiveObject> result = {};

    for (final String transcription in transcriptions) {
      switch (lang) {
        case LocaleHelper.Russian:
          result.addAll(
            _merchants.values.where(
              (e) =>
                  e.nameRu.toLowerCase().contains(transcription.toLowerCase()),
            ),
          );
          break;
        case LocaleHelper.Uzbek:
          result.addAll(
            _merchants.values.where(
              (e) =>
                  e.nameUz.toLowerCase().contains(transcription.toLowerCase()),
            ),
          );
          break;
        case LocaleHelper.English:
          result.addAll(
            _merchants.values.where(
              (e) =>
                  e.nameEn.toLowerCase().contains(transcription.toLowerCase()),
            ),
          );
          break;
      }
    }

    return result.map((e) => e.toEntity()).toList();
  }

  /// Finds merchants by category ID.
  List<MerchantEntity> getMerchantList(int categoryId) {
    final List<MerchantHiveObject> result =
        _merchants.values.where((e) => e.categoryId == categoryId).toList();
    result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return result.map((e) => e.toEntity()).toList();
  }

  /// Finds merchants by list of categories.
  List<MerchantEntity> getMerchantList2(List<int> categoryIds) {
    final Set<MerchantHiveObject> objects = {};

    for (final int categoryId in categoryIds) {
      objects
          .addAll(_merchants.values.where((e) => e.categoryId == categoryId));
    }

    final List<MerchantEntity> result =
        objects.map((e) => e.toEntity()).toList();

    result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return result;
  }

  /// Finds merchants which are not in the list of categories.
  List<MerchantEntity> getOtherMerchantList(List<int> categoryIds) {
    final List<MerchantHiveObject> objects = [..._merchants.values];

    for (final int categoryId in categoryIds) {
      objects.removeWhere((e) => e.categoryId == categoryId);
    }

    final List<MerchantEntity> result =
        objects.map((e) => e.toEntity()).toList();

    result.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return result;
  }

  List<MerchantEntity> getMerchantListByIds(List<int> ids) {
    return _merchants.values
        .where((element) => ids.contains(element.id))
        .map((e) => e.toEntity())
        .toList();
  }
}
