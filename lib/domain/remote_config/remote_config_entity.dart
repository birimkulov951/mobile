class RemoteConfigEntity {
  RemoteConfigEntity({
    required this.walletAnonymousMaxAmountToStore,
    required this.walletAnonymousMaxAmountToTransfer,
    required this.walletConfirmedMaxAmountToStore,
    required this.walletConfirmedMaxAmountToTransfer,
    required this.isVisibleInternationalTransfer,
    required this.p2pMaxTransferAmountWithoutConfirmation,
    required this.analyticsAmplitudeEventsList,
    required this.popularMerchants,
  });

  final double walletAnonymousMaxAmountToStore;
  final double walletAnonymousMaxAmountToTransfer;
  final double walletConfirmedMaxAmountToStore;
  final double walletConfirmedMaxAmountToTransfer;
  final bool isVisibleInternationalTransfer;
  final double p2pMaxTransferAmountWithoutConfirmation;
  final Map<String, bool> analyticsAmplitudeEventsList;
  final List<int> popularMerchants;
}
