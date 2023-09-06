import 'package:flutter_svg/flutter_svg.dart';

const _operationsAssetsPath = 'assets/svg/icons/operations';

SvgPicture _svgAsset(assetName) {
  return SvgPicture.asset(
    '$_operationsAssetsPath/$assetName',
    package: 'paynet_uikit',
  );
}

class OperationIcons {
  OperationIcons._();

  static SvgPicture betweenAccounts =
      _svgAsset('ic_map_operations_between_accounts.svg');

  static final statusBlocked = _svgAsset('ic_operations_status_blocked.svg');
  static final statusCheck = _svgAsset('ic_operations_status_check.svg');
  static final statusDelete = _svgAsset('ic_operations_status_delete.svg');
  static final statusInfo = _svgAsset('ic_operations_status_info.svg');
  static final statusPaused = _svgAsset('ic_operations_status_paused.svg');
  static final statusRepit = _svgAsset('ic_operations_status_repit.svg');
  static final statusWarning = _svgAsset('ic_operations_status_warning.svg');
  static final contacts = _svgAsset('ic_operations_contacts.svg');
  static final contactsLine = _svgAsset('ic_operations_contacts_line.svg');
  static final cashback = _svgAsset('ic_operations_cashback.svg');
  static final support = _svgAsset('ic_operation_support.svg');
  static final bell = _svgAsset('ic_operations_bell.svg');
  static final file = _svgAsset('ic_operations_file.svg');
  static final rocket = _svgAsset('ic_operation_rocket.svg');
}
