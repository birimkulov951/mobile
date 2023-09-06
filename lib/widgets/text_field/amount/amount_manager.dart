import 'package:mobile_ultra/widgets/text_field/postfix/postfix_manager.dart';

class AmountFieldManager extends PostFixFieldManager {
  static final _regExp = RegExp(r'[a-zA-Zа-яА-Я]');

  AmountFieldManager() : super(_regExp);
}
