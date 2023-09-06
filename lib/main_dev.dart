import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/app_config.dart';
import 'package:mobile_ultra/utils/custom_proxy.dart';

CustomProxy? proxy;

void main() {
  // For Android devices you can also allowBadCertificates: true below, but you should ONLY do this when !kReleaseMode
  proxy = CustomProxy(
    port: 8888,
    ipAddress: "localhost",
    allowBadCertificates: !kReleaseMode,
  );

  Config.appFlavor = Flavor.DEVELOPMENT;

  launchApp();
}
