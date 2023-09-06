extension MethodsIterable<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    try {
      return firstWhere(
        test,

        /// Если элемент не найден - бросаем [Exception].
        /// Потому что иначе бросится [StateError],
        /// а он не обработается в блоке catch,
        /// потому что не является наследником от [Exception].
        orElse: () => throw Exception(),
      );
    } on Object catch (_) {
      return null;
    }
  }

  E? singleWhereOrNull(bool Function(E element) test) {
    try {
      return singleWhere(
        test,
        orElse: () => throw Exception(),
      );
    } on Object catch (_) {
      return null;
    }
  }

  E? get firstOrNull {
    try {
      return first;
    } on Object catch (_) {
      return null;
    }
  }

  E? get lastOrNull {
    try {
      return last;
    } on Object catch (_) {
      return null;
    }
  }

  E? elementAtOrNull(index) {
    try {
      if (index >= length) {
        return null;
      }

      return elementAt(index);
    } on Object catch (_) {
      return null;
    }
  }
}
