import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/p2p_info_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/transfer_payment_request.dart';
import 'package:mobile_ultra/data/api/transfer_api.dart';
import 'package:mobile_ultra/data/mappers/transfer_mapper.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/p2p_payment_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_commission_entity.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/exceptions/bank_not_supported_exception.dart';

@Singleton(as: TransferRepository)
class TransferRepositoryImpl extends TransferRepository {
  TransferRepositoryImpl({
    required TransferApi api,
  }) : _api = api;

  final TransferApi _api;

  @override
  Future<CardsByPhoneNumberEntity> getCardsByPhoneNumber(
      String phoneNumber) async {
    final dto = await _api.getCardsByPhoneNumber(phoneNumber);

    return dto.toEntity();
  }

  @override
  Future<P2PInfoEntity> getP2PInfoByHumoPan({
    required String pan,
    String? senderCardToken,
    int? senderCardType,
    int? receiverCardType,
    int? amount,
  }) async {
    try {
      final response = await _api.checkP2PByHumoPan(
        P2PInfoRequest(
          id: pan,
          senderToken: senderCardToken,
          type: P2PCheckType.pan.value,
          receiverCardType: receiverCardType,
          senderCardType: senderCardType,
          amount: amount,
        ),
      );
      return response.toEntity();
    } on DioError catch (error) {
      final requestError = _getRequestError(error: error);
      throw requestError ?? error;
    }
  }

  @override
  Future<P2PInfoEntity> getP2PInfoByUzcardPan({
    required String pan,
    String? senderCardToken,
    int? senderCardType,
    int? receiverCardType,
    int? amount,
  }) async {
    final response = await _api.checkP2PByUzcardPan(
      P2PInfoRequest(
        id: pan,
        senderToken: senderCardToken,
        type: P2PCheckType.pan.value,
        receiverCardType: receiverCardType,
        senderCardType: senderCardType,
        amount: amount,
      ),
    );
    return response.toEntity();
  }

  @override
  Future<P2PInfoEntity> getP2PInfoByPhoneNumber({
    required String id,
    required String bankName,
    required String fullName,
    required int cardType,
    required String maskedPan,
  }) async {
    final response = await _api.checkP2PByPhoneNumber(
      P2PInfoByPhoneNumberRequest(
        bankName: bankName,
        id: id,
        maskedPan: maskedPan,
        cardType: cardType,
        fullName: fullName,
        type: P2PCheckType.phone.value,
      ),
    );
    return response.toEntity();
  }

  @override
  Future<List<PreviousTransferEntity>> fetchPreviousTransfers() async {
    final List<PreviousTransferEntity> result = [];
    final response = await _api.getSavedTransfers(0, 10);
    for (final element in response.savedTransfersList) {
      result.add(element.toEntity());
    }
    return result;
  }

  @override
  Future<List<TransferCommissionEntity>> getCommissions() async {
    try {
      final List<TransferCommissionEntity> result = [];
      final response = await _api.getCommissions();
      for (final element in response) {
        result.add(element.toEntity());
      }
      return result;
    } on DioError catch (_) {
      return [];
    }
  }

  @override
  Future<P2PInfoEntity> getP2PInfoByToken({
    required String receiverCardToken,
    required String senderCardToken,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
  }) async {
    try {
      final response = await _api.checkP2PByToken(
        P2PInfoRequest(
          id: receiverCardToken,
          senderToken: senderCardToken,
          senderCardType: senderCardType,
          receiverCardType: receiverCardType,
          type: P2PCheckType.cardToken.value,
          amount: amount,
        ),
      );
      return response.toEntity();
    } on DioError catch (error) {
      final requestError = _getRequestError(error: error);
      throw requestError ?? error;
    }
  }

  @override
  Future<P2PResultEntity> createP2PTransfer({
    required String receiverCardToken,
    required String senderCardToken,
    required String fio,
    required String? exp,
    required int senderCardType,
    required int receiverCardType,
    required int amount,
    required P2PCheckType receiverMethodType,
    required String? receiverBankName,
  }) async {
    try {
      final p2pPaymentResponse = await _api.createTransfer(
        TransferPaymentRequest(
          senderToken: senderCardToken,
          senderMethodType: P2PCheckType.cardToken.value,
          senderCardType: senderCardType,
          receiverToken: receiverCardToken,
          receiverMethodType: receiverMethodType.value,
          receiverCardType: receiverCardType,
          amount: amount,
          fio: fio,
          exp: exp,
          receiverBankName: receiverBankName,
        ),
      );

      return p2pPaymentResponse.toEntity();
    } on DioError catch (error) {
      final requestError = _getRequestError(error: error);
      throw requestError ?? error;
    }
  }

  Exception? _getRequestError({required DioError error}) {
    final errorBody = error.response?.data;
    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final requestError = RequestError.fromJson(errorBody);
      if (requestError.status == 400) {
        if (requestError.detail == 'not_card_owner_sms_sent') {
          if (requestError.id != null) {
            return OtpException(id: int.parse(requestError.id!));
          }
        } else if (requestError.detail == 'bank_not_supported') {
          if (requestError.title != null) {
            return BankNotSupportedException(title: requestError.title!);
          }
        }
      }
    }
    return null;
  }
}
