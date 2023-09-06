import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/favorite_api.dart';
import 'package:mobile_ultra/data/mappers/favorite_mapper.dart';
import 'package:mobile_ultra/data/storages/database.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/repositories/favorite_repository.dart';

@Singleton(as: FavoriteRepository)
class FavoriteRepositoryimpl extends FavoriteRepository {
  FavoriteRepositoryimpl({
    required this.favoriteApi,
    required this.database,
  });

  final FavoriteApi favoriteApi;
  final MUDatabase database;

  @override
  Future<List<FavoriteEntity>> getMyFavorites() async {
    final fetchedList = await favoriteApi.getMyFavorites();

    database.removeFavorites();
    database.saveFavorites(
      fetchedList.map((e) => e.toJson()).toList(),
    );

    fetchedList.sort((a, b) {
      return a.ord - b.ord;
    });
    return fetchedList.map((e) => e.toEntity()).toList();
  }
}
