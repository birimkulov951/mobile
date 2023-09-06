import 'package:elementary/elementary.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/di/di_container.dart';

abstract class LocaleInteractor {
  static late final instance = getIt.get<LocaleInteractor>();

  abstract final StateNotifier<Map<String, dynamic>> localeState;

  String getText(String key);

  void setLocaleTextData(Map<String, dynamic> newData);
}

/// Интераткор локализации
@Singleton(as: LocaleInteractor)
class LocaleInteractorImpl implements LocaleInteractor {
  /// Состояние локализации
  @override
  final localeState = StateNotifier<Map<String, dynamic>>(initValue: {});

  Map<String, dynamic> get _localeTextData => localeState.value ?? {};

  /// Получить текст из локализации
  @override
  String getText(String key) => _localeTextData[key] ?? key;

  /// Установить новую дату локализации
  @override
  void setLocaleTextData(Map<String, dynamic> newData) {
    localeState.accept(newData);
  }
}
