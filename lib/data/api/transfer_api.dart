import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/p2p_info_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/transfer_payment_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards_by_phone_number_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/p2p_info_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/p2p_payment_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/saved_transfers_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/transfer_commission_response.dart';
import 'package:retrofit/retrofit.dart';

part 'transfer_api.g.dart';

@RestApi()
@Singleton()
abstract class TransferApi {
  @factoryMethod
  factory TransferApi(Dio dio) = _TransferApi;

  @GET('/microservice/api/p2p/cardsByPhoneNumber')
  Future<CardsByPhoneNumberResponse> getCardsByPhoneNumber(
      @Query("phoneNumber") String phoneNumber);

  @POST('/microservice/api/humo/p2p/check')
  Future<P2PInfoResponse> checkP2PByHumoPan(@Body() P2PInfoRequest request);

  @POST('/microservice/api/p2p/check')
  Future<P2PInfoResponse> checkP2PByUzcardPan(@Body() P2PInfoRequest request);

  @POST('/microservice/api/p2p/checkLogin')
  Future<P2PInfoByLoginResponse> checkP2PByLogin(
      @Body() P2PInfoRequest request);

  @POST('/microservice/api/p2p/checkByToken')
  Future<P2PInfoResponse> checkP2PByToken(@Body() P2PInfoRequest request);

  @POST('/microservice/api/p2p/checkByCardId')
  Future<P2PInfoResponse> checkP2PByCardId(@Body() P2PInfoRequest request);

  @POST('/microservice/api/p2p/checkByPhoneNumber')
  Future<P2PInfoResponse> checkP2PByPhoneNumber(
      @Body() P2PInfoByPhoneNumberRequest request);

  @GET('/microservice/api/p2p_receiver_cards_token')
  Future<SavedTransfersResponse> getSavedTransfers(
    @Query("page") int page,
    @Query("size") int size,
  );

  @POST('/microservice/api/p2p/v3/payment')
  Future<P2PPaymentResponse> createTransfer(
      @Body() TransferPaymentRequest transferPaymentRequest);

  @GET('/microservice/api/cards/p2p/commissions')
  Future<List<TransferCommissionResponse>> getCommissions();
}
