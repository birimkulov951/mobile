import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/di/di_container.config.dart';

/// Команда для генерации:
/// flutter packages pub run build_runner build --delete-conflicting-outputs
final getIt = GetIt.instance;

@InjectableInit()
Future<void> initDi() async {
  await $initGetIt(getIt);
  return getIt.allReady();
}

Future<void> disposeDi() {
  return getIt.reset();
}
