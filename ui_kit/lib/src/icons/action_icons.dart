import 'package:flutter_svg/flutter_svg.dart';

const _actionsAssetsPath = 'assets/svg/icons/actions';

SvgPicture _svgAsset(assetName) {
  return SvgPicture.asset(
    '$_actionsAssetsPath/$assetName',
    package: 'ui_kit',
  );
}

class ActionIcons {
  ActionIcons._();

  static final addPerson = _svgAsset('ic_action_add person.svg');
  static final transfers = _svgAsset('ic_action_transfers.svg');
  static final person = _svgAsset('ic_action_person.svg');
  static final chevronRight16 = _svgAsset('ic_chevron_right_x16.svg');
  static final chevronDown16 = _svgAsset('ic_chevron_down_x16.svg');
  static final scan = _svgAsset('ic_action_scan.svg');
  static final scanCard = _svgAsset('ic_action_scan_card.svg');
  static final phoneAlt = _svgAsset('ic_action_phone-alt.svg');
  static final search = _svgAsset('ic_navigation_search_x24.svg');
  static final eyeOpen = _svgAsset('ic_action_eye_open.svg');
  static final eyeClose = _svgAsset('ic_action_eye_close.svg');
  static final plus = _svgAsset('ic_action_plus.svg');
  static final settings = _svgAsset('ic_actions_settings.svg');
  static final addBox = _svgAsset('ic_action_addbox.svg');
  static final move = _svgAsset('ic_action_move.svg');
  static final navigationLeft = _svgAsset('ic_navigation_arrow_left_x24.svg');
  static final close = _svgAsset('ic_navigation_close_x24.svg');
}
