import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/repositories/favorite_repository.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';

mixin FavoriteModelMixin on ElementaryModel {
  @protected
  late final FavoriteRepository favoriteRepository;
  @protected
  late final MerchantRepository merchantRepository;

  Future<List<FavoriteEntity>?> fetchMyFavorites() async {
    try {
      final list = await favoriteRepository.getMyFavorites();
      //TODO(Magomed):для обратной совместимости. убрать когда удалим favoriteList из main
      favoriteList = list;
      return list;
    } on Object catch (error) {
      handleError(error);
    }
    return null;
  }

  Future<MerchantEntity?> findMerchant(int? id) async {
    try {
      return merchantRepository.findMerchant(id);
    } on Object catch (error) {
      handleError(error);
    }
  }
}
