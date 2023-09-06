import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

const String walletAnonymousMaxAmountToStore =
    'wallet_anonymous_max_amount_to_store';
const String walletAnonymousMaxAmountToTransfer =
    'wallet_anonymous_max_amount_to_transfer';

const String walletConfirmedMaxAmountToStore =
    'wallet_confirmed_max_amount_to_store';
const String walletConfirmedMaxAmountToTransfer =
    'wallet_confirmed_max_amount_to_transfer';

const String isVisibleInternationalTransfer =
    'is_visible_international_transfer';
const String p2pMaxTransferAmountWithoutConfirmation =
    'p2p_max_transfer_amount_without_confirmation';
const String analyticsAmplitudeEventsList = 'analytics_amplitude_events_list';
const String popularMerchantIds = 'popular_merchant_ids';

const defaultFetchTimeout = Duration(seconds: 60);
const defaultMinimumFetchInterval = Duration(minutes: 15);

const defaultConfigs = const {
  walletAnonymousMaxAmountToStore: 1500000,
  walletAnonymousMaxAmountToTransfer: 300000,
  walletConfirmedMaxAmountToStore: 150000000,
  walletConfirmedMaxAmountToTransfer: 30000000,
  isVisibleInternationalTransfer: false,
  p2pMaxTransferAmountWithoutConfirmation: 0,
  popularMerchantIds: '[]'
};

@module
abstract class FirebaseRemoteConfigModule {
  @preResolve
  Future<FirebaseRemoteConfig> getInstance() async {
    final instance = FirebaseRemoteConfig.instance;

    await instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: defaultFetchTimeout,
        minimumFetchInterval: defaultMinimumFetchInterval,
      ),
    );

    await instance.setDefaults(defaultConfigs);

    return instance;
  }
}
