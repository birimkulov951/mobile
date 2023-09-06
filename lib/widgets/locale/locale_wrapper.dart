import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/locale/locale_interactor.dart';

/// Виджет перестраивающий UI при изменении локали
class LocaleWrapper extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const LocaleWrapper({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      listenableState: LocaleInteractor.instance.localeState,
      builder: (_, __) => builder(context),
    );
  }
}
