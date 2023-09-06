import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paynet_uikit/src/extentions/svg_picture_ext.dart';
import 'package:paynet_uikit/src/icons/merchant_icons.dart';

final _noDigitsRegExp = RegExp(r'\D');
final _phoneFormatter = MaskedInputFormatter('+000 00 000 00 00');
final fullPhoneLenght = 12;
final shortPhoneLenght = 9;

enum PhoneProvider {
  UCell,
  Beeline,
  Mobiuz,
  UzMobile,
  Perfectum,
  Humans,
}

final Map<PhoneProvider, List<String>> _phoneProviderCodes = Map.fromEntries([
  MapEntry(PhoneProvider.Beeline, ['90', '91']),
  MapEntry(PhoneProvider.UCell, ['93', '94', '55']),
  MapEntry(PhoneProvider.UzMobile, ['95', '99', '77']),
  MapEntry(PhoneProvider.Mobiuz, ['97', '88']),
  MapEntry(PhoneProvider.Perfectum, ['98']),
  MapEntry(PhoneProvider.Humans, ['33']),
]);

PhoneProvider? getPhoneProvider(String phoneNumber,
    {List<PhoneProvider> ignore = const []}) {
  final phoneCode = getPhoneProviderCode(phoneNumber);
  if (phoneCode == null) {
    return null;
  }
  return getPhoneProviderByCode(phoneCode, ignore: ignore);
}

String? tryToFullPhone(String phoneNumber, String countryCode) {
  phoneNumber = phoneNumber.replaceAll(_noDigitsRegExp, '');
  if (phoneNumber.startsWith(countryCode)) {
    return phoneNumber;
  }
  final provider = getPhoneProvider(phoneNumber);
  if (provider != null && phoneNumber.length == shortPhoneLenght) {
    return countryCode + phoneNumber;
  }
  return null;
}

PhoneProvider? getPhoneProviderByCode(String phoneCode,
    {List<PhoneProvider> ignore = const []}) {
  for (final entry in _phoneProviderCodes.entries) {
    if (entry.value.contains(phoneCode)) {
      final provider = entry.key;
      if (!ignore.contains(provider)) {
        return provider;
      }
    }
  }
  return null;
}

bool hasPhoneProvider(String phoneCode) {
  for (final entry in _phoneProviderCodes.entries) {
    if (entry.value.contains(phoneCode)) {
      return true;
    }
  }
  return false;
}

String? getPhoneProviderCode(String phoneNumber,
    {int? customStartIndex, int? customEndIndex}) {
  phoneNumber = phoneNumber.replaceAll(_noDigitsRegExp, '');
  if (phoneNumber.length == fullPhoneLenght) {
    return phoneNumber.substring(3, 5);
  } else if (phoneNumber.length == shortPhoneLenght) {
    return phoneNumber.substring(0, 2);
  } else if (customStartIndex != null) {
    return phoneNumber.substring(customStartIndex, customEndIndex);
  } else {
    return null;
  }
}

Widget? getPhoneProviderIcon(String phoneNumber, {double? size}) {
  final provider = getPhoneProvider(phoneNumber, ignore: [PhoneProvider.Humans]);
  if (provider == null) {
    return null;
  }
  SvgPicture? icon;
  switch (provider) {
    case PhoneProvider.UCell:
      icon = MerchantIcons.ucell;
      break;
    case PhoneProvider.Beeline:
      icon = MerchantIcons.beeline2;
      break;
    case PhoneProvider.Mobiuz:
      icon = MerchantIcons.mobiuz;
      break;
    case PhoneProvider.UzMobile:
      icon = MerchantIcons.uzmobile;
      break;
    case PhoneProvider.Perfectum:
      icon = MerchantIcons.perfectum;
      break;
    default:
      break;
  }
  return icon?.copyWith(width: size, height: size);
}

typedef GetContactCallback = Future<String?> Function();

String formatPhoneNumber(String phoneNumber) {
  return _phoneFormatter.applyMask(phoneNumber).text;
}
