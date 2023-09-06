import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';

class P2PInfoEntity with EquatableMixin {
  P2PInfoEntity({
    required this.pan,
    required this.fio,
    required this.commissionPercent,
    required this.limitIn,
    required this.limitOut,
    this.exp,
    this.receiverToken,
    this.receiverBankName,
    this.userId,
    this.commissionAmount,
    this.commissionPrice,
    this.max,
    this.min,
    this.senderCardType,
    this.receiverCardType,
    this.amount,
    this.type,
  });

  final String pan;
  final String fio;

  final double commissionPercent;
  final int limitIn;
  final int limitOut;
  final String? exp;

  final String? receiverToken;
  final String? receiverBankName;
  final String? userId;
  final double? commissionAmount;
  final double? commissionPrice;

  final int? max;
  final int? min;

  final int? senderCardType;
  final int? receiverCardType;

  final int? amount;
  final P2PCheckType? type;

  @override
  List<Object?> get props => [
        pan,
        fio,
        commissionPercent,
        limitIn,
        limitOut,
        exp,
        receiverToken,
        receiverBankName,
        userId,
        commissionAmount,
        commissionPrice,
        max,
        min,
        senderCardType,
        receiverCardType,
        amount,
        type,
      ];
}
