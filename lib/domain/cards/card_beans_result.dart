import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';

enum CardBeansResultStatus { success, failed }

class CardBeansResult {
  CardBeansResult._({
    required this.status,
    this.result,
    this.error,
  });

  factory CardBeansResult.failed(Object error) {
    return CardBeansResult._(
      status: CardBeansResultStatus.failed,
      error: error,
    );
  }

  factory CardBeansResult.success(
    CardBeansEntity cardBeansEntity,
  ) {
    return CardBeansResult._(
      status: CardBeansResultStatus.success,
      result: cardBeansEntity,
    );
  }

  final Object? error;
  final CardBeansEntity? result;
  final CardBeansResultStatus status;
}
