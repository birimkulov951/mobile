import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/remote_config_repository.dart';

import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_model.dart';

class IdentificationIntroModel extends ElementaryModel
    with RemoteConfigModelMixin {
  IdentificationIntroModel(RemoteConfigRepository remoteConfigRepository) {
    this.remoteConfigRepository = remoteConfigRepository;
  }
}
