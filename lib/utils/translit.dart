class TranslitUtils {
  TranslitUtils._();

  //возвращает возможные варианты слов в другой транскрипции
  //чеб длинее текст тем больше вариантов
  static List<String> getTranslits(String text) {
    text = text.toLowerCase();
    List<String> result = [];
    final char = text.length > 0 ? text[0] : '';
    final nextText = text.length > 1 ? text.substring(1) : '';
    final list = translitMap[char];

    list?.forEach((t) {
      final list = TranslitNode(char: char, translit: t, nextText: nextText)
          .getAllLasts()
          .map((e) => e.toString())
          .toList();
      result.addAll(list);
    });

    return result;
  }
}

class TranslitNode {
  final TranslitNode? parent;

  final List<TranslitNode> children = [];
  final String char;
  final String translit;
  final String nextText;

  TranslitNode({
    this.parent,
    required this.nextText,
    required this.char,
    required this.translit,
  }) {
    _buildTranslits();
  }

  void _buildTranslits() {
    final char = nextText.length > 0 ? nextText[0] : '';
    final next = nextText.length > 1 ? nextText.substring(1) : '';
    final list = translitMap[char];
    list?.forEach((t) {
      children.add(
          TranslitNode(char: char, translit: t, nextText: next, parent: this));
    });
  }

  bool get isLast {
    return children.isEmpty;
  }

  List<TranslitNode> getAllLasts() {
    List<TranslitNode> results = [];
    if (isLast) {
      results.add(this);
    } else {
      children.forEach((element) {
        final lasts = element.getAllLasts();
        results.addAll(lasts);
      });
    }
    return results;
  }

  @override
  String toString() {
    List<String> buffer = [];
    TranslitNode? next = this;
    while (next != null) {
      buffer.add(next.translit);
      next = next.parent;
    }
    return buffer.reversed.join('');
  }
}

final Map<String, List<String>> translitMap = {
  //Cyrillic
  'а': ['a', 'i', 'y'],
  'б': ['b'],
  'в': ['v'],
  'г': ['g'],
  'д': ['d'],
  'е': ['e', 'i', 'y', 'ee', 'ea'],
  'ж': ['j'],
  'з': ['z'],
  'и': ['i', 'e', 'ee', 'ea'],
  'й': ['y', 'i', ''],
  'к': ['k', 'q', 'c'],
  'қ': ['q', 'k', 'c'],
  'л': ['l'],
  'м': ['m'],
  'н': ['n'],
  'о': ['o', 'ou', 'a'],
  'п': ['p'],
  'р': ['r'],
  'с': ['s'],
  'т': ['t'],
  'у': ['u', 'y', 'o', 'ou'],
  'ф': ['f'],
  'ц': ['c'],
  'х': ['x', 'h'],
  'ҳ': ['h'],
  'ю': ['u', 'you'],
  'э': ['e', 'ei', 'ey'],

  //Latinic
  'a': ['а'],
  'b': ['б'],
  'c': ['ц', 'с','к'],
  'd': ['д'],
  'e': ['е','э'],
  'f': ['ф'],
  'g': ['г'],
  'h': ['х'],
  'i': ['и','й'],
  'j': ['дж', 'ж'],
  'k': ['к'],
  'l': ['л'],
  'm': ['м'],
  'n': ['н'],
  'o': ['о'],
  'p': ['п'],
  'q': ['к'],
  'r': ['р'],
  's': ['с','ш'],
  't': ['т'],
  'u': ['у', 'ю'],
  'v': ['в'],
  'w': ['в', 'вв'],
  'x': ['экс', 'кс', 'х'],
  'y': ['и','й'],
  'z': ['з'],
};
