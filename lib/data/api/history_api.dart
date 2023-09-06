import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:retrofit/retrofit.dart';

part 'history_api.g.dart';

@RestApi()
@Singleton()
abstract class HistoryApi {
  @factoryMethod
  factory HistoryApi(Dio dio) = _HistoryApi;

  @GET('microservice/api/trans/paynet/only')
  Future<List<HistoryResponse>> getTransactionsHistory(
    @Query('lang') String lang,
    @Query('limit') int limit,
  );

  @GET('microservice/api/trans/sum/date')
  Future<int> getSumOfTodayExpenditure(@Query('from') String startDate);
}
