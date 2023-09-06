class P2PResultEntity {
  final int id;
  final int amount;
  final int amountCredit;
  final int commission;
  //pan1
  final String senderMaskedPan;
  //pan2
  final String receiverMaskedPan;
  final bool success;
  final String issuedDate;

  const P2PResultEntity({
    required this.id,
    required this.amount,
    required this.amountCredit,
    required this.commission,
    required this.senderMaskedPan,
    required this.receiverMaskedPan,
    required this.success,
    required this.issuedDate,
  });
}
