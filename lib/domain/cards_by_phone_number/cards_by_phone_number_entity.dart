import 'package:equatable/equatable.dart';

class CardsByPhoneNumberEntity with EquatableMixin {
  const CardsByPhoneNumberEntity({
    required this.bankCardsData,
    required this.success,
  });

  final BankCardsEntity bankCardsData;
  final bool success;

  @override
  List<Object> get props => [bankCardsData, success];

  @override
  String toString() {
    return 'CardsByPhoneNumberEntity{data: $bankCardsData, success: $success}';
  }
}

class BankCardsEntity with EquatableMixin {
  const BankCardsEntity({
    required this.paynetCards,
    required this.otherCards,
  });

  final List<BankCardEntity> paynetCards;
  final List<BankCardEntity> otherCards;

  @override
  List<Object> get props => [paynetCards, otherCards];

  @override
  String toString() {
    return 'BankTypeEntity{paynet: $paynetCards, other: $otherCards}';
  }
}

class BankCardEntity with EquatableMixin {
  const BankCardEntity({
    required this.id,
    required this.cardType,
    required this.maskedPan,
    required this.fullName,
    required this.expiry,
    required this.bank,
  });

  final String id;
  final int cardType;
  final String maskedPan;
  final String fullName;
  final String? expiry;
  final BankEntity bank;

  @override
  List<Object?> get props => [
        id,
        cardType,
        maskedPan,
        fullName,
        expiry,
        bank,
      ];

  @override
  String toString() {
    return 'BCardEntity{id: $id, cardType: $cardType, maskedPan: $maskedPan, fullName: $fullName, expiry: $expiry, bank: $bank}';
  }
}

class BankEntity with EquatableMixin {
  const BankEntity({
    required this.bankName,
    required this.logo,
  });

  final String bankName;
  final String logo;

  @override
  List<Object> get props => [bankName, logo];

  @override
  String toString() {
    return 'BankEntity{bankName: $bankName, logo: $logo}';
  }
}
