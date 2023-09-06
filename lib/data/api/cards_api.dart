import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/cards/card_addition_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/cards/card_edit_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/cards/track_payments_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/card_addition_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/card_beans_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/cards_balance_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/track_payments_response.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:retrofit/retrofit.dart';

part 'cards_api.g.dart';

@RestApi()
@singleton
abstract class CardsApi {
  @factoryMethod
  factory CardsApi(Dio dio) = _CardsApi;

  @POST('/microservice/api/humo/cards/v7/register')
  Future<CardAdditionResponse> cardAdditionHumo(
    @Body() CardAdditionRequest cardAdditionRequest,
  );

  @POST('/microservice/api/cards/v6/register')
  Future<CardAdditionResponse> cardAdditionUzcard(
    @Body() CardAdditionRequest cardAdditionRequest,
  );

  @POST('/microservice/api/cards/v1/getbeans')
  Future<CardBeansResponse> getCardBeans();

  @PUT('/microservice/api/cards/v2/update')
  Future<void> editCard(@Body() CardEditRequest cardEditRequest);

  @GET('/microservice/api/cards/v3/main')
  Future<MainData> getAttachedCards();

  @GET('/microservice/api/cards/v3/main/short')
  Future<CardsBalanceResponse> getCardsBalance();

  @DELETE('/microservice/api/cards/delete/{token}')
  Future<void> deleteCard(@Path('token') String token);

  @POST('/microservice/api/subscription')
  Future<TrackPaymentsResponse> trackPayments(
      @Body() TrackPaymentsRequest trackPaymentsRequest);
}
