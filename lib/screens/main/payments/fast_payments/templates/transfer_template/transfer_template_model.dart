import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_model.dart';

class TransferTemplateModel extends ElementaryModel
    with RemoteConfigModelMixin, TransferMixin {
  TransferTemplateModel({
    required RemoteConfigRepository remoteConfigRepository,
    required TransferRepository transferRepository,
  }) {
    this.remoteConfigRepository = remoteConfigRepository;
    this.transferRepository = transferRepository;
  }
}
