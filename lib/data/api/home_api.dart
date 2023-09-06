import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/home/monthly_cashback_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/home/weekly_cashback_response.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@RestApi()
@Singleton()
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(Dio dio) = _HomeApi;

  @GET('microservice/api/paynetId/get')
  Future<List<PaynetId>> getMyAccounts();

  @GET('microservice/api/cards/bonus/amount')
  Future<MonthlyCashbackResponse> getMonthlyCashback();

  @GET('microservice/api/weekly/bonus')
  Future<WeeklyCashbackResponse> getWeeklyCashback();
}
