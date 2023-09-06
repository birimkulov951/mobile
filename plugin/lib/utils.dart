import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:utils/module/contact.dart';

class Utils {
  static const MethodChannel methodChannel =
      const MethodChannel('mobileultra.utils');

  static Future<List<Contact>> getContactList({String? prefix}) async {
    final result = await methodChannel.invokeMethod('getContactList', prefix);

    final Set<Contact> contacts = {};

    result.forEach((item) {
      contacts.add(Contact(
        photo: item['photo'],
        name: item['name'],
        phone: item['phone'].replaceAll('-', '').replaceAll(' ', ''),
      ));
    });

    return contacts.toList();
  }

  static Future<bool> get sunMIPrinterState async => Platform.isAndroid
      ? await methodChannel.invokeMethod("sunMIPrinterState")
      : false;

  static Future printReceipt(String data) async => Platform.isAndroid
      ? methodChannel.invokeMethod("printReceipt", data)
      : () {};

  static Future<bool> checkUpdate() async =>
      await methodChannel.invokeMethod('checkUpdate');
}
