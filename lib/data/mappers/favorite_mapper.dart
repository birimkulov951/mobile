import 'package:mobile_ultra/data/api/dto/responses/favorite_response.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';

extension FavoriteResponseExt on FavoriteResponse {
  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      name: name,
      bill: bill,
      billId: billId,
      order: ord,
    );
  }
}
