import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';

class TemplateEntity with EquatableMixin {
  TemplateEntity({
    required this.id1,
    required this.id2,
    required this.pan1,
    required this.pan2,
    required this.type1,
    required this.type2,
    required this.amount,
    required this.fio,
    required this.exp,
    required this.senderCardType,
    required this.receiverCardType,
    required this.p2pCheckType,
    this.receiverBankName,
  });

  final String id1;
  final String id2;
  final String pan1;
  final String pan2;
  final String type1;
  final String type2;
  final double amount;
  final String fio;
  final int exp;
  final int senderCardType;
  final int receiverCardType;
  final P2PCheckType p2pCheckType;
  final String? receiverBankName;

  @override
  List<Object?> get props => [
        id1,
        id2,
        pan1,
        pan2,
        type1,
        type2,
        amount,
        fio,
        exp,
        senderCardType,
        receiverCardType,
        p2pCheckType,
        receiverBankName,
      ];

  @override
  String toString() {
    return 'TemplateEntity{id1: $id1, id2: $id2, pan1: $pan1, pan2: $pan2, '
        'type1: $type1, type2: $type2, amount: $amount, fio: $fio, '
        'exp: $exp, senderCardType: $senderCardType, '
        'receiverCardType: $receiverCardType, p2pCheckType: $p2pCheckType, '
        'receiverBankName: $receiverBankName}';
  }
}
