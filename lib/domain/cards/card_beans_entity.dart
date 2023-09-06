import 'package:equatable/equatable.dart';

class CardBeansEntity with EquatableMixin {
  const CardBeansEntity({
    this.humo,
    this.uzcard,
  });

  final List<String>? humo;
  final List<String>? uzcard;

  @override
  List<Object?> get props => [
        humo,
        uzcard,
      ];

  @override
  String toString() {
    return 'CardBeansEntity{humo: $humo, uzcard: $uzcard}';
  }
}
