import 'package:flutter_svg/flutter_svg.dart';

const _actionsAssetsPath = 'assets/svg/icons/cards/logo';

SvgPicture _svgAsset(assetName) {
  return SvgPicture.asset(
    '$_actionsAssetsPath/$assetName',
    package: 'paynet_uikit',
  );
}

class Logo {
  Logo._();

  static final uzcard = _svgAsset('ic_uzcard.svg');
  static final humo = _svgAsset('ic_humo.svg');
  static final paynet = _svgAsset('ic_paynet.svg');
}