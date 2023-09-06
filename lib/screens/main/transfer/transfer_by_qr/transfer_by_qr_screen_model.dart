import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';

class TransferTransferByQrScreenModel extends ElementaryModel
    with SystemModelMixin {
  TransferTransferByQrScreenModel(SystemRepository systemRepository) {
    this.systemRepository = systemRepository;
  }
}
