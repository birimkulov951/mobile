import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_manager.dart';

/// Вспомогательный класс для рассчета конверсии валют
class ConversionHelper {
  final double rate;
  final PostfixTextEditingController fromController;
  final PostfixTextEditingController toController;

  String get _rawFromText => fromController.rawTextWithoutPostfix;

  String get _rawToText => toController.rawTextWithoutPostfix;

  double get _fromNum => double.parse(_rawFromText);

  double get _toNum => double.parse(_rawToText);

  ConversionHelper({
    required this.rate,
    required this.fromController,
    required this.toController,
  }) {
    _init();
  }

  void _init() {
    fromController.addListener(_listenFrom);
    toController.addListener(_listenTo);
  }

  void dispose() {
    fromController.removeListener(_listenFrom);
    toController.removeListener(_listenTo);
  }

  void _listenFrom() {
    /// Снимаю обработчик с поля "куда"
    /// Чтобы не было циклической реакции
    toController.removeListener(_listenTo);

    if (_rawFromText.isEmpty) {
      toController.text = '';
    } else {
      /// TODO Временное решение. Сделать расчет по формуле
      toController.text = AmountFormatter.formatNum(
        double.parse((_fromNum / rate).toStringAsFixed(2)),
        isDecimal: true,
      );
    }

    /// Возвращаю обработчки
    toController.addListener(_listenTo);
  }

  void _listenTo() {
    fromController.removeListener(_listenFrom);

    if (_rawToText.isEmpty) {
      fromController.text = '';
    } else {
      /// TODO Временное решение. Сделать расчет по формуле
      fromController.text = AmountFormatter.formatNum(
        (_toNum * rate).round(),
      );
    }

    fromController.addListener(_listenFrom);
  }
}
