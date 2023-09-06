import 'dart:convert';

import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';

abstract class BillData {}

class MerchantData extends BillData {
  MerchantData({
    this.merchantId,
    this.merchantName,
    this.account,
    this.amount,
    this.params,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) => MerchantData(
        merchantId: json['merchantId'],
        merchantName: json['merchantName'],
        account: json['account'],
        amount: json['amount'].toDouble(),
        params: json['params'],
      );
  final int? merchantId;
  final String? merchantName;
  final String? account;
  final double? amount;
  final Map<String, dynamic>? params;

  @override
  String toString() {
    return 'MerchantData{merchantId: $merchantId, merchantName: $merchantName, account: $account, amount: $amount, params: $params}';
  }
}

// TODO (khamidjon): check which data is nullable or not from BE
class TransferData extends BillData {
  TransferData({
    required this.p2pCheckType,
    this.id1,
    this.id2,
    this.pan1,
    this.pan2,
    this.type1,
    this.type2,
    this.amount,
    this.fio,
    this.exp,
    this.senderCardType,
    this.receiverCardType,
    this.receiverBankName,
  });

  factory TransferData.fromJson(Map<String, dynamic> json) => TransferData(
        id1: json['id1'],
        id2: json['id2'],
        pan1: json['pan1'],
        pan2: json['pan2'],
        type1: json['type1'],
        type2: json['type2'],
        amount: json['amount'].toDouble(),
        fio: json['fio'],
        exp: json['exp'],
        senderCardType: json['senderCardType'],
        receiverCardType: json['receiverCardType'],
        p2pCheckType: json['p2pCheckType'].toString().toP2PCheckType(),
        receiverBankName: json['receiverBankName'],
      );
  final String? id1;
  final String? id2;
  final String? pan1;
  final String? pan2;
  final String? type1;
  final String? type2;
  final double? amount;
  final String? fio;
  final int? exp;
  final int? senderCardType;
  final int? receiverCardType;
  final P2PCheckType p2pCheckType;
  final String? receiverBankName;

  @override
  String toString() {
    return 'TransferData{id1: $id1, id2: $id2, pan1: $pan1, pan2: $pan2, type1: $type1, type2: $type2, amount: $amount, fio: $fio, exp: $exp, senderCardType: $senderCardType, receiverCardType: $receiverCardType}';
  }
}

class FavoriteEntity {
  FavoriteEntity({
    required String bill,
    this.id,
    this.name,
    this.billId,
    this.order,
  }) {
    if (billId != null) {
      this.type = FPIType.MERCHANT;
      this.bill = MerchantData.fromJson(jsonDecode(bill));
    } else {
      this.type = FPIType.TRANSFER;
      this.bill = TransferData.fromJson(jsonDecode(bill));
    }
  }

  factory FavoriteEntity.fromJson(Map<String, dynamic> json) => FavoriteEntity(
        id: json['id'],
        name: json['name'],
        billId: json['billId'],
        bill: json['bill'],
        order: json['ord'],
      );
  late final FPIType type;
  final int? id;
  final String? name;
  late final BillData bill;
  final int? billId;
  int? order;

  TransferData? get transferData {
    if (isTransfer) {
      return bill as TransferData;
    }
  }

  MerchantData? get merchantData {
    if (isMerchant) {
      return bill as MerchantData;
    }
  }

  bool get isTransfer {
    return type == FPIType.TRANSFER;
  }

  bool get isMerchant {
    return type == FPIType.MERCHANT;
  }

  @override
  String toString() {
    return 'Favorite{type: $type, id: $id, name: $name, bill: $bill, billId: $billId, order: $order}';
  }
}
