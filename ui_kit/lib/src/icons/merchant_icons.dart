import 'package:flutter_svg/flutter_svg.dart';

final _actionsAssetsPath = 'assets/svg/icons/merchants';

SvgPicture _svgAsset(assetName) {
  return SvgPicture.asset(
    '$_actionsAssetsPath/$assetName',
    package: 'paynet_uikit',
  );
}

class MerchantIcons {
  MerchantIcons._();

  static final uzmobile = _svgAsset('uzmobile.svg');
  static final ucell = _svgAsset('ucell.svg');
  static final perfectum = _svgAsset('perfectum.svg');
  static final beeline2 = _svgAsset('beeline2.svg');
  static final mobiuz = _svgAsset('mobiuz.svg');

  static final bankHumo16 = _svgAsset('ic_bank_humo_x16.svg');
  static final bankUzcard16 = _svgAsset('ic_bank_uzcard_x16.svg');
  static final bankpynet16 = _svgAsset('ic_bank_paynet_x16');
}
