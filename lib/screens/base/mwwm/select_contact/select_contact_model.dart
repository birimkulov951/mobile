import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';

class SelectContactModel extends ElementaryModel with SystemModelMixin {
  SelectContactModel({required SystemRepository systemRepository}) {
    this.systemRepository = systemRepository;
  }
}
