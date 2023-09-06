import 'package:mobile_ultra/extensions/iterable_extension.dart';

enum CardStatus {
  VALID('VALID'),
  INVALID('INVALID'),
  EXPIRED('EXPIRED'),
  BLOCKED('BLOCKED'),
  DISABLED('DISABLED'),
  HUMO_DISABLED('HUMO_DISABLED'),
  UZCARD_DISABLED('UZCARD_DISABLED'),
  LOST_CARD('LOST_CARD'),
  STOLEN_CARD('STOLEN_CARD');

  final String value;

  const CardStatus(this.value);
}

extension CardStatusExtension on String {
  CardStatus toCardStatus() {
    if (this == CardStatus.INVALID.value) {
      return CardStatus.INVALID;
    }
    if (this == CardStatus.EXPIRED.value) {
      return CardStatus.EXPIRED;
    }
    if (this == CardStatus.BLOCKED.value) {
      return CardStatus.BLOCKED;
    }
    if (this == CardStatus.DISABLED.value) {
      return CardStatus.DISABLED;
    }
    if (this == CardStatus.HUMO_DISABLED.value) {
      return CardStatus.HUMO_DISABLED;
    }
    if (this == CardStatus.UZCARD_DISABLED.value) {
      return CardStatus.UZCARD_DISABLED;
    }
    if (this == CardStatus.STOLEN_CARD.value) {
      return CardStatus.STOLEN_CARD;
    }
    if (this == CardStatus.LOST_CARD.value) {
      return CardStatus.LOST_CARD;
    }
    return CardStatus.VALID;
  }
}

class AttachedCard {
  final int? id;
  final int? type;
  final bool? p2pEnabled;
  double? balance;
  final String? bankId;
  int? color;
  final double? limitIn;
  final double? limitOut;
  final String? expDate;
  final String? login;
  final bool? isMain;
  final String? number;
  final String? name;
  final String? phone;
  final String? maskedPhone;
  bool? sms;
  final String? activated;
  CardStatus? status;
  final String? token;
  int? order;
  String? subscribeLastDate;
  bool? subscribed;
  bool? hiddenBalance;
  bool? checked;
  bool? viewTitle;

  AttachedCard({
    this.id,
    this.type,
    this.p2pEnabled,
    this.balance,
    this.bankId,
    this.color,
    this.limitIn,
    this.limitOut,
    this.expDate,
    this.login,
    this.isMain,
    this.number,
    this.name,
    this.phone,
    this.maskedPhone,
    this.sms,
    this.activated,
    this.status,
    this.token,
    this.order,
    this.subscribeLastDate,
    this.subscribed,
    this.hiddenBalance = false,
    this.checked = false,
    this.viewTitle = false,
  });

  factory AttachedCard.fromJson(Map<String, dynamic> json) => AttachedCard(
        id: json['id'],
        type: json['type'],
        p2pEnabled: json['p2pEnabled'],
        balance: (json['balance'] ?? 0) / 100,
        bankId: json['bankId'],
        color: json['color'],
        limitIn: json['estimateLimitIn']?.toDouble(),
        limitOut: json['estimateLimitOut']?.toDouble(),
        expDate: json['expireDate'],
        login: json['login'],
        isMain: json['main'],
        number: json['maskedPan'],
        name: json['name'],
        phone: json['phone'],
        maskedPhone: json['maskedPhone'],
        sms: json['sms'],
        activated: json['activated'],
        status: CardStatus.values.singleWhereOrNull(
            (status) => status.toString() == 'CardStatus.${json['status']}'),
        token: json['token'],
        order: json['order'],
        subscribeLastDate: json['subscribeLastDate'],
        subscribed: json['subscribed'],
      );

  @override
  String toString() {
    return 'Card{id: $id, type: $type, p2pEnabled: $p2pEnabled, balance: $balance, bankId: $bankId, color: $color, limitIn: $limitIn, limitOut: $limitOut, expDate: $expDate, login: $login, isMain: $isMain, number: $number, name: $name, phone: $phone, maskedPhone: $maskedPhone, sms: $sms, activated: $activated, status: $status, token: $token, order: $order, subscribeLastDate: $subscribeLastDate, subscribed: $subscribed, hiddenBalance: $hiddenBalance, checked: $checked, viewTitle: $viewTitle}';
  }

  bool get isActive => activated != 'INACTIVE';
}
