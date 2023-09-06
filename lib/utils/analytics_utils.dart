import 'package:mobile_ultra/interactor/analytics/data/transfer_source_type.dart';
import 'package:mobile_ultra/utils/const.dart';

TransferSourceTypes? getTransferSourceTypesByInt(int? type) {
  if (type == null) {
    return null;
  }

  switch (type) {
    case Const.HUMO:
      return TransferSourceTypes.humo;

    case Const.UZCARD:
      return TransferSourceTypes.uzcard;
    default:
      return null;
  }
}
