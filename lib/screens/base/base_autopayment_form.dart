import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/screens/main/payments/auto_payments/autopayment.dart';
import 'package:mobile_ultra/screens/main/payments/make_payment_state.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/ui_models/various/rounded_rectacle.dart';
import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/route_utils.dart';
import 'package:mobile_ultra/widgets/locale/locale_wrapper.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';

abstract class BaseAutopaymentForm<T extends StatefulWidget>
    extends MakePaymentState<T> {
  AutoPaymentType? action;
  Reminder? reminder;

  bool bySchedule = true, showLoading = false;
  int monthIndex = 0;
  int dropDownValue = 0, dropDownPeriodValue = 0;
  int weekIndex = 0;

  String? btnTitle;

  List<String> weeklyItemsTitle = [
    locale.getText('mon'),
    locale.getText('tue'),
    locale.getText('wed'),
    locale.getText('thu'),
    locale.getText('fri'),
    locale.getText('sat'),
    locale.getText('sun'),
  ];

  GlobalKey<CustomTextFieldState> keyName = GlobalKey();
  GlobalKey<CustomTextFieldState> keyPeriod = GlobalKey();

  Widget get getUI;

  @override
  void initState() {
    super.initState();

    paymentType = PaymentType.ADD_NEW_REMINDER;
    Future.delayed(Duration(milliseconds: 200), () => makeDynamicFields());
  }

  @override
  void onThemeChanged() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final List<dynamic>? args = getListArgumentFromContext(context);
    action = args?[0];
    merchant = args?[1];
    reminder = args?[2];
  }

  @override
  Widget get formWidget {
    bySchedule = action != AutoPaymentType.FastPayment &&
        action != AutoPaymentType.FastPaymentEdit;

    switch (action) {
      case AutoPaymentType.FastPayment:
        title = locale.getText('create_fast_pay');
        btnTitle = locale.getText('create');
        break;
      case AutoPaymentType.FastPaymentEdit:
        title = locale.getText('edit_fast_pay');
        btnTitle = locale.getText('change_2');
        break;
      case AutoPaymentType.Edit:
        title = locale.getText('editing_reminder');
        btnTitle = locale.getText('change_2');
        break;
      default:
        title = locale.getText('creating_reminder');
        btnTitle = locale.getText('create');
        break;
    }

    if (reminder != null) {
      account = PaynetId(
        account: reminder?.account,
        payBill: reminder?.payBill,
      );

      if (action == AutoPaymentType.Edit) {
        monthIndex =
            reminder?.fireMonthDay != null ? reminder!.fireMonthDay! - 1 : 0;
        weekIndex =
            reminder?.fireWeekDay != null ? reminder!.fireWeekDay! - 1 : 0;

        dropDownValue = reminder?.fireMonthDay != null ? 0 : 1;
        dropDownPeriodValue = (reminder?.oneTimeReminder ?? false) ? 1 : 0;

        Future.delayed(Duration(milliseconds: 400), () {
          onSetPeriodDescription();
        });
      }
    }

    return getUI;
  }

  void onChangeScheduleType(bool bySchedule) => setState(() {
        this.bySchedule = !bySchedule;
      });

  void onSelectPeriod() async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          )),
                      Title1(
                        text: 'periodicity',
                        size: 24,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10),
                        child: TextLocale(
                          "create_payments_by_interval",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RoundedRectangle(
                              width: 150,
                              child: Theme(
                                data: ThemeData(
                                  backgroundColor: ColorNode.Box,
                                ),
                                child: DropdownButton(
                                  value: dropDownPeriodValue,
                                  underline: Container(width: 0),
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: [
                                    DropdownMenuItem<int>(
                                        value: 0,
                                        child: Label(
                                            text: 'everytime',
                                            color: dropDownPeriodValue == 0
                                                ? Colors.black
                                                : Colors.grey)),
                                    DropdownMenuItem<int>(
                                        value: 1,
                                        child: Label(
                                            text: 'one_time',
                                            color: dropDownPeriodValue == 1
                                                ? Colors.black
                                                : Colors.grey))
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value is int) {
                                        dropDownPeriodValue = value;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            RoundedRectangle(
                                width: 100,
                                child: Theme(
                                  data: ThemeData(
                                    backgroundColor: ColorNode.Box,
                                  ),
                                  child: DropdownButton(
                                    value: dropDownValue,
                                    underline: Container(width: 0),
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    items: [
                                      DropdownMenuItem<int>(
                                          value: 0,
                                          child: Label(
                                              text: 'month',
                                              color: dropDownValue == 0
                                                  ? Colors.black
                                                  : Colors.grey)),
                                      DropdownMenuItem<int>(
                                          value: 1,
                                          child: Label(
                                              text: 'week',
                                              color: dropDownValue == 1
                                                  ? Colors.black
                                                  : Colors.grey))
                                      //dropDownItem(value: 2, title: locale.getText('day')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value is int) {
                                          dropDownValue = value;
                                        }
                                      });
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                      getScheduleType(setState),
                      RoundedButton(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          title: 'choose',
                          bg: Colors.black,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
              ),
            ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))));

    onSetPeriodDescription();
  }

  Widget getScheduleType(StateSetter setState) {
    switch (dropDownValue) {
      case 0:
        return monthly(setState);
      case 1:
        return weekly(setState);
      default:
        return SizedBox(height: 200);
    }
  }

  Widget monthly(StateSetter setState) => GridView.count(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 15,
        crossAxisCount: 7,
        children: List<Widget>.generate(
            31,
            (index) => Center(
                  child: GestureDetector(
                    child: CircleShape(
                      size: 38,
                      color: monthIndex == index
                          ? ColorNode.Green
                          : Colors.transparent,
                      child: Label(
                        text: '${index + 1}',
                        weight: FontWeight.w500,
                        color: monthIndex == index
                            ? Colors.white
                            : (monthIndex > index ? Colors.grey : Colors.black),
                      ),
                    ),
                    onTap: () => setState(() => monthIndex = index),
                  ),
                )),
      );

  Widget weekly(StateSetter setState) => Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 38, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Label(
              text: 'cycle_day',
              size: 13,
              color: Light.Dismiss,
              weight: FontWeight.w500,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, position) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: RoundedRectangle(
                      color: weekIndex == position
                          ? ColorNode.Green
                          : ColorNode.Box,
                      child: LocaleWrapper(
                        builder: (_) => Label(
                          text: weeklyItemsTitle[position],
                          color: position == weekIndex
                              ? Colors.white
                              : Colors.grey,
                          weight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => setState(() => weekIndex = position),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  String get buildRequest {
    Map<String, dynamic> request = {};

    request["id"] = payBill?.id;

    switch (dropDownValue) {
      case 0:
        request["fireMonthDay"] = monthIndex + 1;
        break;
      case 1:
        request["fireWeekDay"] = weekIndex + 1;
        break;
    }

    request["type"] = "USER";
    request["oneTimeReminder"] = dropDownPeriodValue == 1;

    return jsonEncode(request);
  }

  void onSetPeriodDescription() {
    switch (dropDownValue) {
      case 0:
        keyPeriod.currentState
            ?.setValue(sprintf(locale.getText('period_hint_month'), [
          locale.getText(dropDownPeriodValue == 0 ? 'everytime' : 'one_time'),
          monthIndex + 1,
        ]));
        break;
      case 1:
        keyPeriod.currentState
            ?.setValue(sprintf(locale.getText('period_hint_week'), [
          locale.getText(dropDownPeriodValue == 0 ? 'everytime' : 'one_time'),
          weeklyItemsTitle[weekIndex],
        ]));
        break;
    }
  }

  @override
  void onShowLoading(String message) => setState(() {
        showLoading = true;
      });

  @override
  void onShowContent() => setState(() {
        showLoading = false;
      });

  @override
  void onAttemptMakePay({int? checkTo}) async {
    if (checkTo == null) {
      if (action != AutoPaymentType.FastPayment &&
          (keyPeriod.currentState?.invalidate ?? false)) {
        onFail(locale.getText('select_reminder_period_date'));
        return;
      }
      super.onAttemptMakePay();
    } else
      super.onAttemptMakePay(checkTo: checkTo);
  }

  @override
  void onCheckComplete({Bill? data, String? error}) async {
    if (error != null) {
      onShowContent();
      onFail(error);
      return;
    }

    payBill = data;

    switch (action) {
      case AutoPaymentType.FastPayment:
        String name = keyName.currentState?.text ?? '';

        if (name.length > 10) name = '${name.substring(0, 7)}...';

        if (name.isEmpty) name = locale.getText('fast_pay_title');

        FavoritePresenter.newFavorite(
          data: {
            'billId': data?.id,
            'name': name,
          },
          onSuccess: _onFavoriteSuccess,
          onFail: _onFavoriteFail,
        );
        break;
      case AutoPaymentType.FastPaymentEdit:
        break;
      case AutoPaymentType.Edit:
        break;
      default:
        //ReminderPresenter.addNew(view: this).register(buildRequest);
        break;
    }
  }

  /*@override
  void onRemiderError({String error}) {
    onShowContent();
    onFail(error);
  }

  @override
  void onRemiderSuccess() => Navigator.pop(context, true);*/

  void _onFavoriteFail(String error, errorBody) {
    onShowContent();
    onFail(error);
  }

  void _onFavoriteSuccess({data}) => Navigator.pop(context, true);
}
