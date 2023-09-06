import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';

enum CardsBalanceResultStatus { success, failed }

class CardsBalanceResult {
  CardsBalanceResult._({
    required this.status,
    this.result,
    this.error,
  });

  factory CardsBalanceResult.failed(Object error) {
    return CardsBalanceResult._(
      status: CardsBalanceResultStatus.failed,
      error: error,
    );
  }

  factory CardsBalanceResult.success(
      CardsBalanceEntity cardsBalanceEntity,
      ) {
    return CardsBalanceResult._(
      status: CardsBalanceResultStatus.success,
      result: cardsBalanceEntity,
    );
  }

  final Object? error;
  final CardsBalanceEntity? result;
  final CardsBalanceResultStatus status;
}
