import 'package:mobile_ultra/domain/common/p2p_check_type.dart';

class P2PCheck {
  String? cardID;
  String? byToken;
  final String? pan;
  final String? userId;
  final dynamic payerLogin;
  final dynamic payeeLogin;
  final dynamic fio;
  final dynamic commissionPercent;
  double? amount;
  final dynamic limitIn;
  final dynamic limitOut;
  final String? exp;
  final double? commissionAmount;
  final dynamic commissionPrice;
  final double? min;
  final double? max;
  final dynamic senderCardType;
  dynamic receiverCardType;
  final dynamic id;
  final String? code;
  final dynamic dateBegin;
  final dynamic statusMessage;
  final dynamic historyId;
  String? comment;
  final dynamic statusCode;
  final dynamic dateEnd;
  final bool? hasPaynetCard;
  final bool? hasOtherCard;
  final String? receiverBankName;
  final P2PCheckType p2pCheckType;

  P2PCheck({
    this.cardID,
    this.byToken,
    this.pan,
    this.userId,
    this.payerLogin,
    this.payeeLogin,
    this.fio = '',
    this.commissionPercent = '',
    this.amount = 0,
    this.limitIn,
    this.limitOut,
    this.exp,
    this.commissionAmount = 0,
    this.commissionPrice,
    this.min,
    this.max,
    this.senderCardType,
    this.receiverCardType,
    this.id,
    this.code,
    this.dateBegin,
    this.statusMessage,
    this.historyId,
    this.comment,
    this.statusCode,
    this.dateEnd,
    this.hasPaynetCard,
    this.hasOtherCard,
    this.receiverBankName,
    required this.p2pCheckType,
  });

  factory P2PCheck.fromJson(Map<String, dynamic> json) => P2PCheck(
        byToken: json['receiverToken'],
        id: json['id'],
        userId: json['userId'],
        code: json['code'],
        dateBegin: json['date_begin'],
        statusMessage: json['statusMessage'],
        historyId: json['historyId'],
        pan: json['pan'],
        payerLogin: json['payerLogin'],
        payeeLogin: json['payeeLogin'],
        fio: json['fio'] ?? '',
        commissionPercent: json['commissionPercent'],
        amount: json['amount']?.toDouble() ?? 0,
        limitIn: json['limitIn'],
        limitOut: json['limitOut'],
        exp: json['exp'],
        commissionAmount: json['commissionAmount']?.toDouble() ?? 0,
        commissionPrice: json['commissionPrice'] ?? '',
        min: json['min'].toDouble(),
        max: json['max'].toDouble(),
        senderCardType: json['senderCardType'],
        receiverCardType: json['receiverCardType'],
        comment: json['comment'],
        statusCode: json['statusCode'],
        dateEnd: json['date_end'],
        hasPaynetCard: json['hasPaynetCard'],
        hasOtherCard: json['hasOtherCard'],
        receiverBankName: json['receiverBankName'],
        p2pCheckType: json['type'].toString().toP2PCheckType(),
      );

  @override
  String toString() {
    return 'P2PCheck(\n'
        ' cardID = $cardID\n'
        ' byToken = $byToken\n'
        ' pan = $pan\n'
        ' userId = $userId\n'
        ' payerLogin = $payerLogin\n'
        ' payeeLogin = $payeeLogin\n'
        ' fio = $fio\n'
        ' commissionPercent = $commissionPercent\n'
        ' amount = $amount\n'
        ' limitIn = $limitIn\n'
        ' limitOut = $limitOut\n'
        ' exp = $exp\n'
        ' commissionAmount = $commissionAmount\n'
        ' commissionPrice = $commissionPrice\n'
        ' min = $min\n'
        ' max = $max\n'
        ' senderCardType = $senderCardType\n'
        ' receiverCardType = $receiverCardType\n'
        ' id = $id\n'
        ' code = $code\n'
        ' dateBegin = $dateBegin\n'
        ' statusMessage = $statusMessage\n'
        ' historyId = $historyId\n'
        ' comment = $comment\n'
        ' statusCode = $statusCode\n'
        ' dateEnd = $dateEnd\n'
        ' hasPaynetCard = $hasPaynetCard\n'
        ' hasOtherCard = $hasOtherCard\n'
        ' receiverBankName = $receiverBankName\n'
        ' p2pType = $p2pCheckType\n'
        ')';
  }
}
