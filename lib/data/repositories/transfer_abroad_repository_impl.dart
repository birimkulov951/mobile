import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/create_bill_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/create_bill_response.dart';
import 'package:mobile_ultra/data/api/payment_api.dart';
import 'package:mobile_ultra/data/api/transfer_abroad_api.dart';
import 'package:mobile_ultra/data/mappers/abroad_receiver_mapper.dart';
import 'package:mobile_ultra/data/storages/payment_data_storage.dart';
import 'package:mobile_ultra/data/storages/preference.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/domain/exceptions/status_exception.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/repositories/transfer_abroad_repository.dart';

const _abroadToKazMerchantId = 15590;

@Singleton(as: TransferAbroadRepository)
class TransferAbroadRepositoryImpl extends TransferAbroadRepository {
  TransferAbroadRepositoryImpl({
    required this.mapper,
    required this.abroadApi,
    required this.paymentDataStorage,
    required this.preference,
    required this.merchantApi,
  });

  final AbroadReceiverMapper mapper;
  final TransferAbroadApi abroadApi;
  final PaymentDataStorage paymentDataStorage;
  final Preference preference;
  final PaymentApi merchantApi;

  @override
  Future<List<AbroadTransferReceiverEntity>> getLastReceivers() async {
    final paginable = await abroadApi.getLastReceivers();

    return paginable.content.map((dto) => mapper.toEntity(dto)).toList();
  }

  @override
  Future<AbroadTransferReceiverEntity> getReceiverByPan(String pan) async {
    final receiverDTO = await abroadApi.getReceiverByPan(pan);

    return mapper.toEntity(receiverDTO);
  }

  //по хорошему логика из этого метода должна находится в usecae(model),
  //но так как для MUDatabase и Preference отсутствует интерфейсного слоя
  //не стал нарушать принцип зависимости чистой архитектуры
  @override
  Future<AbroadTransferRateEntity> getTransferRate({
    required int merchantId,
    required String pan,
    double? payAmount,
  }) async {
    //TODO: use injectable when will move to di
    // final lang = locale.prefix;
    final merchant = (paymentDataStorage.findMerchant(merchantId))!;

    final account = pan;
    final minAmount = merchant.minAmount.toInt();
    final maxAmount = merchant.maxAmount.toInt();
    final phoneNumber = preference.getViewLogin;
    final checkId = merchant.infoServiceId!;
    final payId = merchant.paymentServiceId!;
    final currencyType = _getCurrencyType(merchantId);

    final request = CreateBillRequest(
        account: account,
        amount: minAmount,
        merchantId: merchantId,
        merchantName: merchant.name,
        checkId: checkId,
        payId: payId,
        params: {
          "account": account,
          "phoneNumber": phoneNumber,
          "currency_type": currencyType,
          "pay_amount": payAmount?.toString() ?? minAmount.toString()
        });

    final billResponse = await merchantApi.createBill(request);

    final params = billResponse.responseParams;

    _checkResponseJson(params);

    final rateMap = params.details['rate'];
    final rate = double.parse(rateMap['value']);

    final amountMap = params.details['amount'];
    final amount = double.parse(amountMap['value']);

    final calculatedPayAmountMap = params.details['pay_amount'];
    final calculatedPayAmount = double.parse(calculatedPayAmountMap['value']);

    return AbroadTransferRateEntity(
      rate: rate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      amount: amount,
      payAmount: calculatedPayAmount,
      billId: billResponse.id,
    );
  }

  void _checkResponseJson(BillResponseParams params) {
    if (!params.success) {
      throw StatusException(params.status, params.statusText);
    }
  }

  //TODO захардкодено так как в мерчанте храниться 3 типа валюты UZS, USD и KZT и не понятно как выбрать нужный
  String _getCurrencyType(int merchantId) {
    switch (merchantId) {
      case _abroadToKazMerchantId:
        {
          return 'KZT';
        }
    }
    return '';
  }
}
