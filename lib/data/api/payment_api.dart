import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/create_bill_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/payment_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/create_bill_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/favorite_response.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_api.g.dart';

@RestApi()
@Singleton()
abstract class PaymentApi {
  @factoryMethod
  factory PaymentApi(Dio dio) = _PaymentApi;

  @POST('microservice/api/trans/v3/payment')
  Future<Payment> payFromUzcardV3(@Body() PaymentRequest request);

  @POST('microservice/api/humo/trans/v3/payment')
  Future<Payment> payFromHumoV3(@Body() PaymentRequest request);

  @POST('pms2/api/pynet/act2')
  Future<CreateBillResponse> createBill(@Body() CreateBillRequest request);

  @GET('pms2/api/favorites/mine')
  Future<List<FavoriteResponse>> getFavorites({
    @Query('page') required int page,
    @Query('size') required int size,
  });
}
