import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/firebase/firebase_remote_config_module.dart';
import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';

@Singleton(as: RemoteConfigRepository)
class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  RemoteConfigRepositoryImpl(FirebaseRemoteConfig firebaseRemoteConfig)
      : _firebaseRemoteConfig = firebaseRemoteConfig;

  final FirebaseRemoteConfig _firebaseRemoteConfig;

  @override
  Future<RemoteConfigEntity> getRemoteConfig() async {
    await _firebaseRemoteConfig.fetchAndActivate();

    final popularMerchants = List<int>.from(
      jsonDecode(
        _firebaseRemoteConfig.getString(popularMerchantIds),
      ),
    );

    return RemoteConfigEntity(
      walletAnonymousMaxAmountToStore:
          _firebaseRemoteConfig.getDouble(walletAnonymousMaxAmountToStore),
      walletAnonymousMaxAmountToTransfer:
          _firebaseRemoteConfig.getDouble(walletAnonymousMaxAmountToTransfer),
      walletConfirmedMaxAmountToStore:
          _firebaseRemoteConfig.getDouble(walletConfirmedMaxAmountToStore),
      walletConfirmedMaxAmountToTransfer:
          _firebaseRemoteConfig.getDouble(walletConfirmedMaxAmountToTransfer),
      isVisibleInternationalTransfer:
          _firebaseRemoteConfig.getBool(isVisibleInternationalTransfer),
      p2pMaxTransferAmountWithoutConfirmation: _firebaseRemoteConfig
          .getDouble(p2pMaxTransferAmountWithoutConfirmation),
      analyticsAmplitudeEventsList: Map<String, bool>.from(
        jsonDecode(
          _firebaseRemoteConfig.getString(analyticsAmplitudeEventsList),
        ),
      ),
      popularMerchants: popularMerchants,
    );
  }
}
