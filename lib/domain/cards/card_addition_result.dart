import 'package:mobile_ultra/domain/cards/card_addition_entity.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_already_exists_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_active_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_or_sms_info_is_off_exception.dart';

enum CardAdditionResultStatus {
  success,
  cardNotFound,
  cardAlreadyExists,
  cardNotFountOrSmsInfoIsOff,
  cardNotActive,
  failed,
}

class CardAdditionResult {
  CardAdditionResult._({
    required this.status,
    this.result,
    this.error,
  });

  factory CardAdditionResult.success(
    CardAdditionEntity p2pPaymentEntity,
  ) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.success,
      result: p2pPaymentEntity,
    );
  }

  factory CardAdditionResult.cardNotFound(CardNotFoundException error) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.cardNotFound,
      error: error,
    );
  }

  factory CardAdditionResult.cardAlreadyExists(
    CardAlreadyExistsException error,
  ) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.cardAlreadyExists,
      error: error,
    );
  }

  factory CardAdditionResult.cardNotFountOrSmsInfoIsOff(
    CardNotFountOrSmsInfoIsOffException error,
  ) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.cardNotFountOrSmsInfoIsOff,
      error: error,
    );
  }

  factory CardAdditionResult.cardNotActive(
    CardNotActiveException error,
  ) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.cardNotActive,
      error: error,
    );
  }

  factory CardAdditionResult.failed(Object error) {
    return CardAdditionResult._(
      status: CardAdditionResultStatus.failed,
      error: error,
    );
  }

  final Object? error;
  final CardAdditionEntity? result;
  final CardAdditionResultStatus status;
}
