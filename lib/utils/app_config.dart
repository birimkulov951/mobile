import 'package:mobile_ultra/utils/const.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return Const.APP_NAME;
      case Flavor.DEVELOPMENT:
      default:
        return Const.APP_NAME_DEV;
    }
  }

  static bool get isDebug {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return false;
      case Flavor.DEVELOPMENT:
      default:
        return true;
    }
  }
}
