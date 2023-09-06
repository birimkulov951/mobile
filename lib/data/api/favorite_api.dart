import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/pageable_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/favorite_response.dart';
import 'package:retrofit/retrofit.dart';

part 'favorite_api.g.dart';

@RestApi()
@singleton
abstract class FavoriteApi {
  @factoryMethod
  factory FavoriteApi(Dio dio) = _FavoriteApi;

  @GET('pms2/api/favorites/mine')
  Future<List<FavoriteResponse>> getMyFavorites({
    @Queries() PageableRequest request = const PageableRequest(size: 1000),
  });
}
