import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChosenPaymentCardStorage {
  final Box _paynetLocalStorage;

  const ChosenPaymentCardStorage(this._paynetLocalStorage);

  Future<void> saveLastPickedCardId({required int? pickedCardId}) async {
    log('picked card id is $pickedCardId');
    await _paynetLocalStorage.put('card_id', pickedCardId);
  }

  Future<int?> getLastPickedCardId() async {
    final cardId = await _paynetLocalStorage.get('card_id');
    log('getting card id is $cardId');
    return cardId;
  }
}
