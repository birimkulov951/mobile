import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class SystemModule {
  @preResolve
  @singleton
  Future<PackageInfo> createPackageInfo() => PackageInfo.fromPlatform();
}
