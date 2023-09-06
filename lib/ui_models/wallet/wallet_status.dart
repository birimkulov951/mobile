import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/ui_models/wallet/wallet_item_status_container.dart';

class WalletStatus extends StatelessWidget {
  final bool isActive;

  WalletStatus({
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) => WalletItemStatusContainer(
        title: locale.getText(isActive ? 'confirmed' : 'anonymous'),
        status: locale.getText('user_status'),
        subtitle: locale
            .getText(isActive ? 'max_features' : 'min_features'), //max_features
      );
}
