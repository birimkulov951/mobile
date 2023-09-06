import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mobile_ultra/main.dart' show getAccessToken, reminderList;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/utils/const.dart';

class ReminderPresenter extends Http with HttpView {
  static const GetList = 1;
  static const AddNew = 2;
  static const Delete = 3;
  static const Update = 4;
  static const Edit = 5;

  int action;

  final Function({dynamic data})? onComplete;
  final ValueChanged<String>? onError;

  ReminderPresenter(
    String path,
    this.action, {
    this.onComplete,
    this.onError,
  }) : super(path: path);

  factory ReminderPresenter.list({
    Function({dynamic data})? onSuccess,
  }) =>
      ReminderPresenter(
        'microservice/api/autoPayment/get',
        GetList,
        onComplete: onSuccess,
      ).._getList();

  factory ReminderPresenter.addNew({
    String? data,
    Function({dynamic data})? onSuccess,
    ValueChanged<String>? onError,
  }) =>
      ReminderPresenter(
        'microservice/api/autoPayment/register',
        AddNew,
        onComplete: onSuccess,
        onError: onError,
      ).._register(data);

  factory ReminderPresenter.edit({
    String? data,
    Function({dynamic data})? onSuccess,
    ValueChanged<String>? onError,
  }) =>
      ReminderPresenter(
        'microservice/api/autoPayment/edit',
        Edit,
        onComplete: onSuccess,
        onError: onError,
      ).._register(data);

  factory ReminderPresenter.delete(
    int id, {
    Function({dynamic data})? onSuccess,
    ValueChanged<String>? onError,
  }) =>
      ReminderPresenter(
        'microservice/api/autoPayment/delete/$id',
        Delete,
        onComplete: onSuccess,
        onError: onError,
      ).._confirm();

  factory ReminderPresenter.updateReminder(
    int id, {
    Function({dynamic data})? onSuccess,
    ValueChanged<String>? onError,
  }) =>
      ReminderPresenter(
        'microservice/api/autoPayment/checkIn/$id',
        Update,
        onComplete: onSuccess,
        onError: onError,
      ).._update();

  void _getList() =>
      makeGet(this, header: {Const.AUTHORIZATION: getAccessToken()});

  /// for new reminder/edit reminder
  void _register(String? data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: data,
      );

  /// for delete
  void _confirm() =>
      makeDelete(this, header: {Const.AUTHORIZATION: getAccessToken()});

  /// for update reminder after pay. updates next payment date
  void _update() => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  @override
  void onFail(String details, {String? title, dynamic errorBody}) =>
      onError?.call(title ?? details);

  @override
  void onSuccess(body) async {
    switch (action) {
      case GetList:
        List<dynamic> response = jsonDecode(body);

        reminderList.clear();
        response.forEach((reminder) {
          reminderList.add(Reminder.fromJson(reminder));
        });
        onComplete?.call();
        break;
      case AddNew:
        final reminder = Reminder.fromJson(jsonDecode(body));
        try {
          final pos = reminderList.indexWhere((item) => item.id == reminder.id);
          reminderList.replaceRange(pos, pos + 1, [reminder]);
          onComplete?.call();
        } on Object catch (_) {
          reminderList.add(reminder);
          onComplete?.call(data: reminder);
        }
        break;
      case Edit:
        final reminder = Reminder.fromJson(jsonDecode(body));
        final pos = reminderList.indexWhere((item) => item.id == reminder.id);
        reminderList.replaceRange(pos, pos + 1, [reminder]);
        onComplete?.call(data: reminder);
        break;
      default:
        onComplete?.call();
        break;
    }
  }
}
