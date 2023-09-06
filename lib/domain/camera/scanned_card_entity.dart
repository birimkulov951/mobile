import 'package:equatable/equatable.dart';

class ScannedCardEntity with EquatableMixin {
  const ScannedCardEntity({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolder,
  });

  final String cardNumber;
  final String expiryDate;
  final String cardHolder;

  bool get hasExpiryDate => expiryDate.isNotEmpty;

  bool get hasCardHolder => cardHolder.isNotEmpty;

  @override
  List<Object> get props => [
        cardNumber,
        expiryDate,
        cardHolder,
      ];

  @override
  String toString() {
    return 'ScannedCardEntity(${props.join(',')})';
  }
}
