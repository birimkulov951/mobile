import 'package:mobile_ultra/data/api/dto/responses/cards/card_balance_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/cards_balance_response.dart';
import 'package:mobile_ultra/domain/cards/card_balance_entity.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';

extension CardsBalanceResponseToEntity on CardsBalanceResponse {
  CardsBalanceEntity toEntity() => CardsBalanceEntity(
        totalBalance: totalBalance,
        cardsBalance:
            cardsBalance.map((cardBalance) => cardBalance.toEntity()).toList(),
      );
}

extension _CardBalanceResponseToEntity on CardBalanceResponse {
  CardBalanceEntity toEntity() => CardBalanceEntity(
        token: token,
        balance: balance,
        status: status.toCardStatus(),
        sms: sms,
      );
}
