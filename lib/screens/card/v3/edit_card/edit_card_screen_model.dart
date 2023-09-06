import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/cards/track_payments_entity.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_model.dart';

class EditCardScreenModel extends ElementaryModel with AttachedCardsModelMixin {
  EditCardScreenModel({required CardsRepository cardsRepository}) {
    this.cardsRepository = cardsRepository;
  }

  Future<TrackPaymentsEntity?> trackPayments({
    required String? token,
    required String? account,
    required bool subscribe,
  }) async {
    try {
      return await cardsRepository.trackPayments(
        token: token ?? '',
        account: account ?? '',
        subscribe: subscribe,
      );
    } on Object catch (e) {
      handleError(e);
      return null;
    }
  }
}
