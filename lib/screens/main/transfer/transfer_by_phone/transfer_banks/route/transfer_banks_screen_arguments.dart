import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';

class TransferBanksScreenRouteArguments with EquatableMixin {
  //удалить после полного перехода transfer v3
  final String? phoneNumber;
  final List<BankCardEntity> bankCards;

  const TransferBanksScreenRouteArguments({
    this.phoneNumber,
    this.bankCards = const [],
  });

  @override
  List<Object?> get props => [
        phoneNumber,
        bankCards,
      ];
}
