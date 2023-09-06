import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/screens/main/payments/auto_payments/autopayment.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/book_fund/book_fund_add_to_widget.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/gnk/gnk_autopayment.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/mib_bpi/mib_bpi_autopayment.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sprintf/sprintf.dart';

final _digitalsRegex = RegExp(r'\d');

String moneyFormat(num? number) {
  if (number == null) {
    return '';
  }

  final String splitter = " ";
  final isNegative = number.isNegative;
  number = number.abs();
  String result = "0";
  result = NumberFormat().format(number).split(",").join(splitter);
  return isNegative ? "-$result" : result;
}

String dateParse(String date) {
  if (DateFormat("yyyy-MM-dd").format(DateTime.now()) ==
      date.split("T").first) {
    return sprintf("${locale.getText("today")}, %s", [
      DateFormat("HH:mm", "ru").format(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date),
      )
    ]);
  }
  return DateFormat("dd.MM.yyyy, HH:mm").format(
    DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date),
  );
}

String moneyFormatSymbol(num number) {
  final String splitter = " ";
  final isNegative = number.isNegative;
  number = number.abs();
  String result = "0";
  result = NumberFormat().format(number).split(",").join(splitter);
  return "${isNegative ? "-$result" : result} ${locale.getText('sum')}";
}

String formatAmount(
  double? amount, {
  bool isHidden = false,
  bool withDecimals = true,
}) {
  final formatter =
      withDecimals ? NumberFormat('#,###.##') : NumberFormat('#,###');
  final String newText = formatter.format(amount ?? 0.0);
  final value = newText.replaceAll(',', ' ');
  if (isHidden) {
    return '• •••';
  }
  return value;
}

String aesEncrypt(String pass, String value) {
  final key = Encrypt.Key.fromUtf8("..............$pass..............");
  final iv = Encrypt.IV.fromLength(16);
  final encrypter = Encrypt.Encrypter(Encrypt.AES(key));
  return encrypter.encrypt(value, iv: iv).base64;
}

String aesDecrypt(String pass, String value) {
  final key = Encrypt.Key.fromUtf8("..............$pass..............");
  final iv = Encrypt.IV.fromLength(16);
  final encrypter = Encrypt.Encrypter(Encrypt.AES(key));

  try {
    return encrypter.decrypt64(value, iv: iv);
  } on Object catch (e) {
    printLog(e.toString());
    return 'error';
  }
}

String formatCardNumber(String? number) {
  if (number == null) {
    return '';
  } else if (number.contains(' ')) {
    return number;
  }

  String result = '';
  if (number.length == 16) {
    for (int i = 0; i < number.length; i = i + 4) {
      if ((i + 4) <= number.length) result += number.substring(i, i + 4) + " ";
    }
    return result;
  } else
    return number.trim();
}

String lowerCasedCardName(String? name) {
  if (name == null) {
    return '';
  }
  final firstName = name.split(' ')[0];
  final formattedFirstName = firstName.substring(0, 1).toUpperCase() +
      firstName.substring(1).toLowerCase();

  final lastName = name.split(' ')[1];
  final formattedlastName = lastName.substring(0, 1).toUpperCase() +
      lastName.substring(1).toLowerCase();

  return "$formattedFirstName $formattedlastName";
}

String formatCardNumberSecondary(String number) {
  if (number.length > 4)
    return '**** ${number.substring(number.length - 4, number.length)}';
  return number;
}

String formatPayeeLogin(String? number) {
  if (number == null) {
    return '';
  } else if (number.contains(' ')) {
    return number;
  }

  if (!number.startsWith('+998') && number.length == 9) {
    number = '+998$number';
  }

  String star = '';
  if (number.contains('+')) {
    star = '+';
    number = number.replaceAll('+', '');
  }

  String result = '';

  try {
    final format = '### ## ### ## ##';
    int offset = 1;

    for (int i = 0; i < number.length; i++) {
      result += number[i];

      final fPos = min(i + offset, format.length - 1);
      if (format[fPos] != '#') {
        offset++;
        result += format[fPos];
      }
    }
    return '$star$result';
  } on Object catch (_) {
    return number;
  }
}

String formatLoyalCardNumber(String number) {
  try {
    number = number.replaceAll(' ', '');
    return '${number.substring(0, 2)}${formatPayeeLogin(number.substring(2))}';
  } on Object catch (_) {
    return number;
  }
}

String formatStarsPhone(String? number) {
  if (number == null) {
    return '';
  }

  String result = number.replaceAll('+', '').replaceAll(' ', '');

  try {
    result = '+' +
        result.substring(0, 5) +
        '•••••' +
        result.substring(10, result.length);
    result = formatPayeeLogin(result);
  } on Object catch (_) {}

  return result;
}

String? formatExpDate(String? date) {
  return date == null
      ? null
      : (date.length > 2 && !date.contains('/'))
          ? '${date.substring(2, date.length)}/${date.substring(0, 2)}'
          : date;
}

String dateFormat(String? date) {
  if (date == null) {
    return '';
  }

  DateTime today = DateTime.now();
  final DateTime inDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);

  today = DateTime(today.year, today.month, today.day);
  final incomingDate = DateTime(inDate.year, inDate.month, inDate.day);

  final difference = today.difference(incomingDate);

  if (difference.inDays == 0)
    return sprintf(
      locale.getText('today_at'),
      [DateFormat('HH:mm').format(inDate)],
    );
  else if (difference.inDays == 1)
    return sprintf(
      locale.getText('yesterday_at'),
      [DateFormat('HH:mm').format(inDate)],
    );
  else
    return DateFormat('dd.MM.yyyy HH:mm').format(inDate);
}

String dateFormatHistory(String? date) {
  if (date == null) {
    return '';
  }

  DateTime today = DateTime.now();
  final DateTime inDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);

  today = DateTime(today.year, today.month, today.day);
  final incomingDate = DateTime(inDate.year, inDate.month, inDate.day);

  final difference = today.difference(incomingDate);

  if (difference.inDays == 0)
    return locale.getText('today');
  else if (difference.inDays == 1)
    return locale.getText('yesterday');
  else
    return DateFormat('dd.MM.yyyy').format(inDate);
}

String dateFormatInMonths(DateTime date) {
  String monthString = '';

  switch (date.month) {
    case 1:
      monthString = locale.getText('mth_1');
      break;
    case 2:
      monthString = locale.getText('mth_2');
      break;
    case 3:
      monthString = locale.getText('mth_3');
      break;
    case 4:
      monthString = locale.getText('mth_4');
      break;
    case 5:
      monthString = locale.getText('mth_5');
      break;
    case 6:
      monthString = locale.getText('mth_6');
      break;
    case 7:
      monthString = locale.getText('mth_7');
      break;
    case 8:
      monthString = locale.getText('mth_8');
      break;
    case 9:
      monthString = locale.getText('mth_9');
      break;
    case 10:
      monthString = locale.getText('mth_10');
      break;
    case 11:
      monthString = locale.getText('mth_11');
      break;
    case 12:
      monthString = locale.getText('mth_12');
      break;
  }

  return '${date.day} $monthString';
}

void printLog(dynamic data) {
  if (kDebugMode) {
    developer.log('log info: $data');
  }
}

Future<String?> get directoryPath async => Platform.isAndroid
    ? (await getExternalStorageDirectory())?.path
    : (await getLibraryDirectory()).path;

String getBalanceTypeDesc(PynetId? account) {
  if (account == null) {
    return '';
  }

  /* ElectroEnergy */
  if (account.merchantId == 481) {
    return locale.getText((account.lastBalance ?? 0) < 0 ? 'debt' : 'credit');
  }

  switch (account.balanceType) {
    case 1:
      return locale.getText('current_balance');
    case 2:
      return locale.getText('recommended_pay');
    case 5:
      return locale.getText('last_pay');
    case 6:
      return locale.getText('prepay');
    default:
      return '';
  }
}

String getBalanceDesc(PynetId? account) {
  if (account == null) {
    return '';
  }

  switch (account.balanceType) {
    case 1:
      return locale.getText(
        (account.lastBalance ?? 0) < 0 ? 'debt_you_have' : 'no_debt',
      );
    case 5:
      return locale.getText(
        account.lastBalance != 0 ? 'last_pay_amount' : 'no_last_pay',
      );
    default:
      return '';
  }
}

String getAutoPayWidgetTag(int? merchantId) {
  switch (merchantId) {
    case 6070:
    case 3469:
      return GNKAutoPaymentWidget.Tag;
    case 7289:
      return BookFundAddToWidget.Tag;
    case 9169:
      return MIBBPIAutoPaymentWidget.Tag;
    default:
      return AutoPaymentWidget.Tag;
  }
}

Future<void> readSharingData() async {
  try {
    sharingData = await ReceiveSharingIntent.getInitialText();
    if (sharingData == null) {
      sharingData = (await ReceiveSharingIntent.getInitialTextAsUri())?.origin;
    }

    printLog('sharingData: $sharingData');

    ReceiveSharingIntent.reset();
  } on Object catch (e) {
    sharingData = null;
    printLog('ReceiveSharingIntent except: ${e.toString()}');
  }
}

String getCardStatusDescription(AttachedCard? card) {
  if (card == null) {
    return locale.getText('unknown_card_status');
  }

  switch (card.status) {
    case CardStatus.EXPIRED:
      return locale.getText('expired');
    case CardStatus.BLOCKED:
      return locale.getText('blocked');
    case CardStatus.DISABLED:
      return locale.getText('disabled');
    default:
      return locale.getText('invalid_${card.type == 1 ? 'uzcard' : 'humo'}');
  }
}

String favoriteTemplateName(FavoriteEntity item) {
  if (item.name != null && item.name!.isNotEmpty) {
    return item.name!;
  } else {
    if (item.bill == null) {
      return '';
    }

    if (item.isMerchant) {
      final merchantData = item.merchantData!;
      var account = merchantData.account;
      final merchantName = merchantData.merchantName ?? '';
      if (account != null && account.length > 3) {
        account = account.substring(account.length - 4, account.length);
      }
      return '$merchantName ••• $account';
    } else if (item.isTransfer) {
      final transferData = item.transferData!;
      return transferData.fio ?? '';
    }
    return '';
  }
}

String reminderTemplateName(Reminder item) {
  if (item.name != null && item.name!.isNotEmpty) {
    return item.name!;
  } else {
    var account = item.account;

    if (account != null && account.length > 3) {
      account = account.substring(account.length - 4, account.length);
    }
    return '••• $account';
  }
}

String transferTemplateName(String? receiverName, String? pan) {
  if (receiverName != null && receiverName.isNotEmpty) {
    return receiverName;
  } else {
    var hiddenPan = '';

    if (pan != null && pan.length > 3) {
      hiddenPan = ' ••• ${pan.substring(pan.length - 4, pan.length)}';
    }

    return '${locale.getText('p2p')}$hiddenPan';
  }
}

String? calculatePercentage(double bonus, double amount) {
  if (bonus != 0 && amount != 0) {
    final percentage = amount * bonus / 100;
    return formatAmount(percentage, isHidden: false, withDecimals: false);
  }
  return null;
}

String cardNumberAndTypeText(String pan, int type) {
  if (type == Const.BONUS) {
    final bonusCardPan = pan.replaceAll('LOYAL', '');

    return '${locale.getText('bonus_card')}'
        ' • ${bonusCardPan.substring(bonusCardPan.length - 4)}';
  }

  if (type == Const.HUMO) {
    return 'Humo • ${pan.substring(pan.length - 4)} ';
  } else if (type == Const.UZCARD) {
    try {
      final card =
          homeData?.cards.firstWhere((element) => element.token == pan);

      return 'uzcard • ${card!.number!.substring(card.number!.length - 4)} ';
    } on Object catch (_) {
      return 'uzcard • ${pan.substring(pan.length - 4)}';
    }
  }

  return ' • ${pan.substring(pan.length - 4)}';
}

bool isCardValid(CardStatus? cardStatus) {
  return cardStatus == CardStatus.VALID;
}
