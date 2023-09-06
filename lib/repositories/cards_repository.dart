import 'package:mobile_ultra/domain/cards/card_addition_entity.dart';
import 'package:mobile_ultra/domain/cards/card_addition_req_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';
import 'package:mobile_ultra/domain/cards/track_payments_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';

abstract class CardsRepository {
  Future<CardAdditionEntity> cardAdditionHumo(
    CardAdditionReqEntity request,
  );

  Future<CardAdditionEntity> cardAdditionUzcard(
    CardAdditionReqEntity request,
  );

  Future<CardBeansEntity> getCardBeans({bool isFromDB = true});

  void saveCardToDB(CardAdditionEntity entity);

  Future<void> editCard(CardEditEntity cardEditEntity);

  Future<MainData> getAttachedCards();

  Future<void> removeCards();

  void saveCards(List<AttachedCard> cards);

  Future<List<AttachedCard>?> readStoredCards();

  Future<CardsBalanceEntity> getCardsBalance();

  void updateCardsBalance(CardsBalanceEntity cardsBalanceEntity);

  Future<void> deleteCard(String token);

  Future<TrackPaymentsEntity> trackPayments({
    required String token,
    required String account,
    required bool subscribe,
  });
}
