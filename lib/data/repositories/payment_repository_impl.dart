import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/create_bill_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/payment_request.dart';
import 'package:mobile_ultra/data/api/payment_api.dart';
import 'package:mobile_ultra/data/mappers/bill_mapper.dart';
import 'package:mobile_ultra/data/mappers/favorite_mapper.dart';
import 'package:mobile_ultra/data/storages/chosen_payment_card_storage.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/repositories/payment_repository.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/exceptions/phone_number_not_found_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';
import 'package:mobile_ultra/utils/const.dart';

const _phoneNumberNotFoundStatusCode = 16;

@Singleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({
    required ChosenPaymentCardStorage chosenPaymentCardStorage,
    required PaymentApi confirmationApi,
    required BillMapper billMapper,
  })  : this._chosenPaymentCardStorage = chosenPaymentCardStorage,
        this._billMapper = billMapper,
        this._paymentApi = confirmationApi;

  final ChosenPaymentCardStorage _chosenPaymentCardStorage;
  final PaymentApi _paymentApi;
  final BillMapper _billMapper;

  @override
  Future<int?> getLastPickedCardId() async {
    return await _chosenPaymentCardStorage.getLastPickedCardId();
  }

  @override
  Future<void> saveLastPickedCardId({required int? pickedCardId}) async {
    await _chosenPaymentCardStorage.saveLastPickedCardId(
      pickedCardId: pickedCardId,
    );
  }

  @override
  Future<Payment> payFromHumo({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    try {
      final transferDto = PaymentRequest(
        billId: billId,
        token: token,
        cardType: cardType,
      );

      return await _paymentApi.payFromHumoV3(transferDto);
    } on DioError catch (error) {
      final requestError = _getRequestError(
        error: error,
        billId: billId,
      );
      throw requestError ?? error;
    }
  }

  @override
  Future<Payment> payFromUzcard({
    required int billId,
    required String token,
    required int cardType,
  }) async {
    try {
      final transferDto = PaymentRequest(
        billId: billId,
        token: token,
        cardType: cardType,
      );

      return await _paymentApi.payFromUzcardV3(transferDto);
    } on DioError catch (error) {
      final requestError = _getRequestError(
        error: error,
        billId: billId,
      );
      throw requestError ?? error;
    }
  }

  @override
  Future<Bill> createBill({
    required MerchantEntity merchant,
    required String account,
    required int amount,
    required Map<String, dynamic> params,
  }) async {
    final request = CreateBillRequest(
      account: account,
      amount: amount,
      merchantId: merchant.id,
      merchantName: merchant.name,
      checkId: merchant.infoServiceId,
      payId: merchant.paymentServiceId,
      params: params,
    );

    final billResponse = await _paymentApi.createBill(request);

    if (billResponse.status == _phoneNumberNotFoundStatusCode) {
      throw PhoneNumberNotFoundException();
    }

    return _billMapper.toEntity(billResponse);
  }

  Exception? _getRequestError({required DioError error, required int billId}) {
    final errorBody = error.response?.data;
    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final requestError = RequestError.fromJson(errorBody);
      if (requestError.status == 400 &&
          requestError.detail == 'not_card_owner_sms_sent') {
        return OtpException(id: billId);
      }
    }
    return null;
  }

  @override
  Future<Payment> makePayment({
    required int billId,
    required String token,
    required int cardType,
  }) {
    if (cardType == Const.HUMO) {
      return this.payFromHumo(
        billId: billId,
        token: token,
        cardType: cardType,
      );
    } else {
      return this.payFromUzcard(
        billId: billId,
        token: token,
        cardType: cardType,
      );
    }
  }

  @override
  Future<List<FavoriteEntity>> getFavorites() async {
     final list = await _paymentApi.getFavorites(page: 0, size: 1000);
     return list.map((e) => e.toEntity()).toList();
  }
}
