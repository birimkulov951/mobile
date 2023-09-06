import 'package:mobile_ultra/domain/favorite/favorite.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getMyFavorites();
}
