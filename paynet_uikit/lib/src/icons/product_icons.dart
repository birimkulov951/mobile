import 'package:flutter_svg/flutter_svg.dart';

const _actionsAssetsPath = 'assets/svg/icons/product';

SvgPicture _svgAsset(assetName) {
  return SvgPicture.asset(
    '$_actionsAssetsPath/$assetName',
    package: 'paynet_uikit',
  );
}

class ProductIcons {
  ProductIcons._();

  static final paynetTextLogo = _svgAsset('ic_paynet_text_logo.svg');
  static final humoTextLogo = _svgAsset('ic_humo_text_logo.svg');
  static final uzcardTextLogo = _svgAsset('ic_uzcard_text_logo.svg');
  static final accountPlaceholderAdd = _svgAsset('ic_account_placeholder_add_56x40.svg');
}