import 'package:flutter/widgets.dart';

/// Запросить фокус
void requestFocus(BuildContext context, FocusNode node) =>
    FocusScope.of(context).requestFocus(node);

/// Сбросить фокус
void resetFocus(BuildContext context) {
  /// Если есть возможность снять фокус у текущего фокуса - снимаем
  if (FocusManager.instance.primaryFocus != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  } else {
    /// Иначе задаем новый фокус,
    /// Так как он ни к чему не привязан - эффект тот же
    /// Первый способ предпочтительнее
    requestFocus(context, FocusNode());
  }
}
