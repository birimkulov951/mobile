import 'package:mobile_ultra/utils/app_config.dart';
import 'package:mobile_ultra/main.dart';

Future main() async {
  Config.appFlavor = Flavor.RELEASE;

  launchApp();
}
