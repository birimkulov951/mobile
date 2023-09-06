import 'package:equatable/equatable.dart';

class CardAdditionEntity with EquatableMixin {
  const CardAdditionEntity({
    this.id,
    this.token,
    this.name,
    this.maskedPan,
    this.status,
    this.phone,
    this.balance,
    this.sms,
    this.bankId,
    this.login,
    this.main,
    this.color,
    this.expireDate,
    this.createdDate,
    this.activated,
    this.order,
    this.activatedDate,
    this.bankName,
    this.type,
    this.p2pEnabled,
    this.subscribed,
    this.subscribeLastDate,
    this.entryCount,
    this.valid,
    this.maskedPhone,
  });

  final int? id;
  final String? token;
  final String? name;
  final String? maskedPan;
  final String? status;
  final String? phone;
  final double? balance;
  final bool? sms;
  final String? bankId;
  final String? login;
  final bool? main;
  final int? color;
  final String? expireDate;
  final String? createdDate;
  final String? activated;
  final int? order;
  final String? activatedDate;
  final String? bankName;
  final int? type;
  final bool? p2pEnabled;
  final bool? subscribed;
  final String? subscribeLastDate;
  final int? entryCount;
  final bool? valid;
  final String? maskedPhone;

  @override
  List<Object?> get props => [
        id,
        token,
        name,
        maskedPan,
        status,
        phone,
        balance,
        sms,
        bankId,
        login,
        main,
        color,
        expireDate,
        createdDate,
        activated,
        order,
        activatedDate,
        bankName,
        type,
        p2pEnabled,
        subscribed,
        subscribeLastDate,
        entryCount,
        valid,
        maskedPhone,
      ];

  @override
  String toString() {
    return 'CardAdditionEntity{id: $id, token: $token, name: $name,'
        ' maskedPan: $maskedPan, status: $status, phone: $phone, '
        'balance: $balance, sms: $sms, bankId: $bankId, login: $login, '
        'main: $main, color: $color, expireDate: $expireDate, '
        'createdDate: $createdDate, activated: $activated, order: $order, '
        'activatedDate: $activatedDate, bankName: $bankName, type: $type, '
        'p2pEnabled: $p2pEnabled, subscribed: $subscribed, '
        'subscribeLastDate: $subscribeLastDate, entryCount: $entryCount, '
        'valid: $valid, maskedPhone: $maskedPhone}';
  }
}
