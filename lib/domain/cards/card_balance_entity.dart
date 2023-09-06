import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/net/card/model/card.dart';

class CardBalanceEntity with EquatableMixin {
  const CardBalanceEntity({
    required this.token,
    required this.balance,
    required this.status,
    required this.sms,
  });

  final String token;
  final double balance;
  final CardStatus status;
  final bool sms;

  @override
  List<Object> get props => [
        token,
        balance,
        status,
        sms,
      ];
}
