import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui_kit/ui_kit.dart';

final _cardFormatter = MaskedInputFormatter('0000 0000 0000 0000');

typedef ScanCardCallback = Future<String?> Function();

final _noDigitsRegExp = RegExp(r'\D');
final minLength = _cardTemplates.map((e) => e.length.minNum).reduce(min);
final maxLength = _cardTemplates.map((e) => e.length.maxNum).reduce(max);

const List<_CardTemplate> _cardTemplates = const [
  _CardTemplate(
    type: CardType.Humo,
    code: _FewValue([
      986035,
      55553660,
      55553664,
      55553621,
      40734200,
      41878300,
      55553667,
      55553668,
      55553665,
      55553666,
      55553661,
      55553662,
      40084700,
      41981300,
      55553650,
      986036,
      40628800,
      42943400,
      55553688,
      986033,
      986032,
      986060,
      986034,
      986001,
      986002,
      986003,
      986004,
      986006,
      986008,
      986009,
      986010,
      986012,
      986013,
      986014,
      986015,
      986016,
      986017,
      986018,
      986019,
      986020,
      986021,
      986023,
      986024,
      986025,
      986026,
      986027,
      986028,
      986029,
      986030,
      986031
    ]),
    length: _RangedValue(6, 16),
  ),
  _CardTemplate(
    type: CardType.Uzcard,
    code: _FewValue([
      56146801,
      6262570,
      54408100,
      6262730,
      6262560,
      62629601,
      6262920,
      62642511,
      62642512,
      6262630,
      62629622,
      6262820,
      62624701,
      62624700,
      62624702,
      62641800,
      62641801,
      62641802,
      62641803,
      62641804,
      56146800,
      62642517,
      62642516,
      62629113,
      62629112,
      62629110,
      6262910,
      62642504,
      62642505,
      62629111,
      56146802,
      56146804,
      6262480,
      62629628,
      62629629,
      62642503,
      6262550,
      6262490,
      62629648,
      6262720,
      6262830,
      6262530,
      860060,
      860061,
      860001,
      860002,
      860063,
      561468142,
      860062,
      56146806,
      56146803,
      62624801,
      56146807,
      56146805,
      56146811,
      56146809,
      56146804101,
      56146804110,
      56146804111,
      56146810,
      56146808,
      626257034,
      626257033,
      626257032,
      626257031,
      62625702,
      62625701,
      626257037,
      626257036,
      626257035,
      54408127,
      54408126,
      54408115,
      54408102,
      54408113,
      54408125,
      54408124,
      54408101,
      54408114,
      54408108,
      54408123,
      54408122,
      54408104,
      54408107,
      54408103,
      54408106,
      54408105,
      54408109,
      54408116,
      54408121,
      54408120,
      54408110,
      54408119,
      54408118,
      54408117,
      54408112,
      56146819,
      56146821,
      56146825,
      62628204,
      62628202,
      56146815,
      62627201,
      62627203,
      62627202,
      56146814,
      5614681433,
      5614681431,
      561468143,
      561468141,
      62629201,
      56146813,
      62629101,
      6262480101,
      62624801003,
      561468071,
      561468073,
      561468072,
      544081005,
      62628301,
      62630119,
      56146824,
      56146823,
      56146822,
      62642522,
      62642521,
      62642509,
      62642510,
      544081001,
      544081002,
      544081003,
      544081004,
      860003,
      860004,
      860005,
      860006,
      860007,
      860008,
      860009,
      860010,
      860011,
      860012,
      860013,
      860014,
      860015,
      860016,
      860017,
      860018,
      860019,
      860020,
      860021,
      860022,
      860023,
      860024,
      860025,
      860026,
      860027,
      860028,
      860029,
      860030,
      860031,
      860032,
      860033,
      860034,
      860035,
      860036,
      860037,
      860038,
      860039,
      860040,
      860041,
      860042,
      860043,
      860044,
      860045,
      860046,
      860047,
      860048,
      860049,
      860050,
      860051,
      860052,
      860053,
      860054,
      860055,
      860056,
      860057,
      860058,
      860059,
      626253091,
      626253046,
      626253096,
      626253092,
      54408128,
      54408129,
      54408130,
      54408131,
      561468007,
      56146812,
      56146816,
      56146817,
      56146820,
      56146818
    ]),
    length: _RangedValue(6, 16),
  ),

  //TODO: расскоментировать нужный тип
  // _CardTemplate(
  //   type: CardType.Visa,
  //   code: _OneValue(4),
  //   length: _OneValue(16),
  // ),
  // _CardTemplate(
  //   type: CardType.MasterCard,
  //   code: _RangedValue(51, 55),
  //   length: _OneValue(16),
  // ),
  // _CardTemplate(
  //     type: CardType.MasterCard,
  //     code: _RangedValue(2221, 2720),
  //     length: _OneValue(16)),
  // _CardTemplate(
  //   type: CardType.Maestro,
  //   code: _FewValue([5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763]),
  //   length: _RangedValue(12, 19),
  // ),
  // _CardTemplate(
  //   type: CardType.Mir,
  //   code: _RangedValue(2200, 2204),
  //   length: _OneValue(16),
  // ),
];

enum CardType {
  Humo,
  Uzcard,
  Visa,
  MasterCard,
  AmericanExpress,
  Maestro,
  Mir,
  UnionPay,
  DinersClub,
  Jcb,
  Discover,
}

class CardNumber {
  CardNumber({
    required this.type,
    required this.number,
  });

  final CardType type;
  final String number;
}

class _CardTemplate {
  const _CardTemplate({
    required this.type,
    required this.code,
    required this.length,
  });

  final CardType type;
  final _Value code;
  final _Value length;
}

abstract class _Value {
  bool isThereValue(num value);

  num get maxNum;

  num get minNum;
}

class _OneValue implements _Value {
  const _OneValue(this.value);

  final num value;

  @override
  bool isThereValue(num value) {
    return this.value == value;
  }

  @override
  num get maxNum => value;

  @override
  num get minNum => value;
}

class _RangedValue implements _Value {
  const _RangedValue(this.from, this.to);

  final num from;
  final num to;

  @override
  bool isThereValue(num value) {
    return value >= from && value <= to;
  }

  @override
  num get maxNum => max(from, to);

  @override
  num get minNum => min(from, to);
}

class _FewValue implements _Value {
  const _FewValue(this.values);

  final List<num> values;

  @override
  bool isThereValue(num value) {
    return values.contains(value);
  }

  @override
  num get maxNum => values.reduce(max);

  @override
  num get minNum => values.reduce(min);
}

_CardTemplate? getCardTemplate(String cardNumber) {
  if (cardNumber.isEmpty) {
    return null;
  }
  cardNumber = cardNumber.replaceAll(_noDigitsRegExp, '');
  //лунна походка
  for (int i = cardNumber.length; i > 0; i--) {
    final code = int.parse(cardNumber.substring(0, i));
    final cardTemplates = _cardTemplates.where((card) {
      return card.code.isThereValue(code) &&
          card.length.isThereValue(cardNumber.length);
    }).toList();

    if (cardTemplates.length == 1) {
      return cardTemplates[0];
    }
  }
  return null;
}

CardType? getCardType(String cardNumber) {
  return getCardTemplate(cardNumber)?.type;
}

bool isCardType(CardType type, String cardNumber) {
  return getCardType(cardNumber) == type;
}

bool isHumo(String cardNumber) {
  return isCardType(CardType.Humo, cardNumber);
}

bool isUzcard(String cardNumber) {
  return isCardType(CardType.Uzcard, cardNumber);
}

String formatCardNumber(String cardNumber) {
  cardNumber = cardNumber.replaceAll(_noDigitsRegExp, '');
  final cardType = getCardType(cardNumber);
  if (cardType != null) {
    return _cardFormatter.applyMask(cardNumber).text;
  }
  return cardNumber;
}

String lastFour(String cardNumber) {
  return cardNumber.substring(cardNumber.length - 4, cardNumber.length);
}

String cardNameTrailing(String cardNumber) {
  return ' • ${lastFour(cardNumber)}';
}

Widget _cardIconContainer({
  SvgPicture? icon,
  Color? bg,
  double containetWidth = 56,
  double containerHeight = 40,
  double iconWidth = 24,
  double iconHeight = 24,
}) {
  return Container(
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    width: containetWidth,
    height: containerHeight,
    child: Center(
      child: icon?.copyWith(width: iconWidth, height: iconHeight),
    ),
  );
}

Widget cardIconFronType(int? cardType,
    {Color bg = BackgroundColors.surfaceLight}) {
  SvgPicture? icon;

  if (cardType == 4) {
    icon = MerchantIcons.bankHumo16;
  }
  if (cardType == 1) {
    icon = MerchantIcons.bankUzcard16;
  }
  if (cardType == 5) {
    icon = MerchantIcons.bankPaynet16;
  }
  return _cardIconContainer(icon: icon, bg: bg);
}

Widget cardIconFromPan(String pan, {Color bg = BackgroundColors.surfaceLight}) {
  final cardType = getCardType(pan);

  SvgPicture? icon;

  switch (cardType) {
    case CardType.Humo:
      icon = MerchantIcons.bankHumo16;
      break;
    case CardType.Uzcard:
      icon = MerchantIcons.bankUzcard16;
      break;
  }
  return _cardIconContainer(icon: icon, bg: bg);
}

Widget cardBrandTextLogoFromType(int? cardType) {
  SvgPicture? icon;

  if (cardType == 4) {
    icon = ProductIcons.humoTextLogo;
  } else if (cardType == 1) {
    icon = ProductIcons.uzcardTextLogo;
  } else if (cardType == 2) {
    icon = ProductIcons.paynetTextLogo;
  }

  return icon ?? const SizedBox.shrink();
}

SvgPicture bigCardLogo(int? cardType) {
  SvgPicture icon;

  if (cardType == 1) {
    icon = Logo.uzcard;
  } else if (cardType == 4) {
    icon = Logo.humo;
  } else {
    icon = Logo.paynet;
  }
  return icon;
}
