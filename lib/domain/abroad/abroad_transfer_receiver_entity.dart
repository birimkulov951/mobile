import 'package:equatable/equatable.dart';

class AbroadTransferReceiverEntity with EquatableMixin {
  const AbroadTransferReceiverEntity({
    required this.bankName,
    required this.pan,
    required this.maskedPan,
    required this.bankIconUrl,
  });

  final String pan;
  final String maskedPan;
  final String? bankName;
  final String? bankIconUrl;

  @override
  List<Object?> get props => [
        maskedPan,
        pan,
        bankName,
        bankIconUrl,
      ];

  @override
  String toString() {
    return 'AbroadReceiverEntity($bankName, $pan, $maskedPan, $bankIconUrl)';
  }
}
