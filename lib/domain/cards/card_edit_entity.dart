import 'package:equatable/equatable.dart';

class CardEditEntity with EquatableMixin {
  const CardEditEntity({
    required this.name,
    required this.token,
    required this.order,
    required this.color,
    required this.main,
  });

  final String name;
  final String? token;
  final int order;
  final int color;
  final bool main;

  @override
  List<Object?> get props => [
        name,
        token,
        order,
        color,
        main,
      ];
}
