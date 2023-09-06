import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/abroad_receiver_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/paginable_response.dart';
import 'package:retrofit/retrofit.dart';

part 'transfer_abroad_api.g.dart';

@RestApi()
@Singleton()
abstract class TransferAbroadApi {
  @factoryMethod
  factory TransferAbroadApi(Dio dio) = _TransferAbroadApi;

  @GET('/microservice/api/foreign/cards/')
  Future<PaginableResponse<AbroadReceiverResponse>> getLastReceivers();

  @GET('/microservice/api/banks/hermes/{pan}')
  Future<AbroadReceiverResponse> getReceiverByPan(@Path() String pan);
}
