import 'package:equatable/equatable.dart';

class CardAdditionReqEntity with EquatableMixin {
  CardAdditionReqEntity({
    required this.color,
    required this.expiry,
    required this.main,
    required this.pan,
    required this.name,
    required this.order,
    required this.type,
    this.token,
  });

  final int color;
  final String expiry;
  final bool main;
  final String pan;
  String name;
  final int order;
  int type;
  final String? token;

  @override
  List<Object?> get props => [
        color,
        expiry,
        main,
        pan,
        name,
        order,
        type,
        token,
      ];

  @override
  String toString() {
    return "CardAdditionReqEntity{color: $color, expiry: $expiry,"
        " main: $main, pan: $pan, name: $name, order: $order, token: $token,"
        " type: $type}";
  }
}
