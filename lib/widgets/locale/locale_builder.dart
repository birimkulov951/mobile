import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/locale/locale_interactor.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';

typedef LocaleBuilderCallback = Widget Function(
  BuildContext context,
  LocaleHelper locale,
);

/// Виджет перестраивающий UI при изменении локали
/// С предоставлением ссылки на лоакль
class LocaleBuilder extends StatelessWidget {
  final LocaleBuilderCallback builder;

  const LocaleBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      listenableState: LocaleInteractor.instance.localeState,
      builder: (_, __) => builder(context, LocaleHelper.instance),
    );
  }
}
