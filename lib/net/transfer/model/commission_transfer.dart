class CommissionTransfer {
  final int? sender;
  final int? receiver;
  final double? commission;

  CommissionTransfer({
    this.sender,
    this.receiver,
    this.commission,
  });

  factory CommissionTransfer.fromJson(Map<String, dynamic> json) =>
      CommissionTransfer(
        sender: json['sender'],
        receiver: json['receiver'],
        commission: json['commission'],
      );

  @override
  String toString() {
    return 'sender type: $sender; receiver type: $receiver; commission: $commission';
  }
}
