import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/domain/cards/card_addition_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';

/// todo refactor to hive
@injectable
class CardsStorage {
  Future<CardBeansEntity?> readCardBeans() async =>
      await db?.readCardBeansAlternative();

  Future<void> storeCardBeans(CardBeansEntity entity) async =>
      await db?.storeCardBeansAlternative(entity);

  void saveCard(CardAdditionEntity entity) async {
    final card = AttachedCard(
      id: entity.id,
      token: entity.token,
      name: entity.name,
      number: entity.maskedPan,
      status: CardStatus.values.singleWhereOrNull(
        (status) => status.toString() == 'CardStatus.${entity.status}',
      ),
      phone: entity.phone,
      balance: entity.balance,
      sms: entity.sms,
      bankId: entity.bankId,
      login: entity.login,
      isMain: entity.main,
      color: entity.color,
      expDate: entity.expireDate,
      activated: entity.activated,
      order: entity.order,
      type: entity.type,
      p2pEnabled: entity.p2pEnabled,
      subscribed: entity.subscribed,
      subscribeLastDate: entity.subscribeLastDate,
      maskedPhone: entity.maskedPhone,
    );
    db?.saveCard(card);
  }
}
