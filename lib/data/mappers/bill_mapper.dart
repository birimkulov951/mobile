import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/create_bill_response.dart';
import 'package:mobile_ultra/data/mappers/entity_mapper_base.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';

@Singleton()
class BillMapper implements ToEntityMapper<Bill, CreateBillResponse> {
  @override
  Bill toEntity(CreateBillResponse dto) {
    return Bill(
        id: dto.id,
        merchantName: dto.merchantName,
        merchantId: dto.merchantId,
        account: dto.account,
        amount: dto.amount,
        login: dto.login,
        status: dto.status,
        statusMessage: dto.statusMessage,
        requestJson: dto.requestJson,
        responseJson: json.encode(dto.responseParams),
        requestTime: dto.requestTime,
        responseTime: dto.responseTime,
        tranId: dto.tranId);
  }
}
