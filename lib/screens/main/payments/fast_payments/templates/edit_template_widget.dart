import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:sprintf/sprintf.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/reminder_presenter.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/adding_template_result_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/select_periodicity_widget.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

enum TemplateEditResult {
  Changed,
  Removed,
}

class EditTemplateWidget extends StatefulWidget {
  final PaymentParams? paymentParams;

  const EditTemplateWidget({this.paymentParams});

  @override
  State<StatefulWidget> createState() => _EditTemplateWidgetState();
}

class _EditTemplateWidgetState
    extends BasePaymentPageState<EditTemplateWidget> {
  bool createSchedule = false;
  bool everyWeek = true;
  TextEditingController _periodicCtrl = TextEditingController();
  int reminderDay = 1;

  @override
  void initState() {
    //order matters
    this.paymentParams = widget.paymentParams;
    super.initState();
    canPay = true;

    if (paymentParams?.templateType == TemplateType.Reminder) {
      createSchedule = true;
      everyWeek = paymentParams?.remider?.fireWeekDay != null;
      reminderDay = paymentParams?.remider?.fireWeekDay ??
          paymentParams?.remider?.fireMonthDay ??
          reminderDay;
      formatReminderPerios();
    }

    Future.delayed(
      const Duration(milliseconds: 250),
      () => makeDynamicFields(),
    );
  }

  @override
  void dispose() {
    _periodicCtrl.dispose();
    super.dispose();
  }

  @override
  String get buttonTitle => locale.getText('save_template');

  @override
  bool get enabledFields => true;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PaynetAppBar(
              'edit_template',
            ),
            body: scrolledForm,
          ),
          LoadingWidget(
            showLoading: blockBtn,
          ),
        ],
      );

  @override
  Widget get cardLayout => SizedBox();

  @override
  Widget get additionLayout => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: SwitchListTile(
              key: const Key(WidgetIds.basePaymentScheduleSwitcher),
              value: createSchedule,
              title: TextLocale('set_schedule'),
              inactiveTrackColor: ColorNode.GreyScale300,
              activeTrackColor: ColorNode.Green.withOpacity(.3),
              onChanged: (value) => setState(() {
                if (!value) {
                  reminderDay = 1;
                }
                createSchedule = value;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  super.didChangeDependencies();
                });
              }),
            ),
          ),
          Visibility(
            visible: createSchedule,
            child: ItemContainer(
              padding: EdgeInsets.only(
                left: 16,
                top: 12,
                right: 16,
                bottom: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLocale(
                    'periodicity',
                    style: TextStyles.captionButton,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      ItemContainer(
                        backgroundColor: everyWeek
                            ? ColorNode.MainIcon
                            : ColorNode.Background,
                        child: InkWell(
                          key: const Key(WidgetIds.basePaymentOnceInWeek),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: TextLocale(
                              'one_time_in_week',
                              style: TextStyles.captionButton.copyWith(
                                color: everyWeek ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (!everyWeek) {
                              setState(() {
                                everyWeek = true;
                                reminderDay = 1;
                                _periodicCtrl.text = '';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      ItemContainer(
                        backgroundColor: !everyWeek
                            ? ColorNode.MainIcon
                            : ColorNode.Background,
                        child: InkWell(
                          key: const Key(WidgetIds.basePaymentOnceInMonth),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: TextLocale(
                              'one_time_in_month',
                              style: TextStyles.captionButton.copyWith(
                                color: !everyWeek ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (everyWeek) {
                              setState(() {
                                everyWeek = false;
                                reminderDay = 1;
                                _periodicCtrl.text = '';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    child: TextField(
                      key: const Key(WidgetIds.basePaymentPeriodicityInput),
                      controller: _periodicCtrl,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: locale.getText('periodicity'),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: SvgPicture.asset(Assets.calendar),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final result = await viewModalSheet<int?>(
                        context: context,
                        child: SelectPeriodicityWidget(
                          everyWeek: everyWeek,
                          period: reminderDay,
                        ),
                      );

                      if (result != null) {
                        reminderDay = result;
                        formatReminderPerios();
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );

  @override
  List<Widget> get buttonLayoutItems {
    final items = super.buttonLayoutItems;
    items.add(buttonDeleteTemplate);
    return items;
  }

  Widget get buttonDeleteTemplate => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: RoundedButton(
          key: const Key(WidgetIds.basePaymentDeleteTemplate),
          bg: Colors.transparent,
          child: TextLocale(
            'delete_template',
            style: TextStyles.captionButtonSecondary,
          ),
          onPressed: removeTemplate,
        ),
      );

  @override
  void makeFields(List conditions,
      {bool isNextFocusClick = true,
      bool clearAccount = true,
      double topOffset = 0}) {
    super.makeFields(conditions,
        isNextFocusClick: isNextFocusClick,
        clearAccount: clearAccount,
        topOffset: topOffset);

    templateNameField = DynamicField(
      key: GlobalKey<DynamicFieldState>(),
      fieldInfo: MerchantField(
        label: locale.getText('template_name'),
        typeName: 'template_name',
      ),
      action: TextInputAction.done,
      merchant: paymentParams?.merchant,
      backgroundColor: fieldBackgroundColor,
      defaultValue: paymentParams?.title,
      forceBlock: !enabledFields,
      maxLength: 20,
    );
  }

  @override
  void onCheckComplete({Bill? data, String? error}) async {
    if (error != null) {
      onLoad(load: false);
      onFail(error);
      return;
    }

    payBill = data;

    if (payBill?.status != 0) {
      onLoad(load: false);
      onFail(payBill?.statusMessage);
    } else {
      autoInfoRequest = false;

      switch (paymentParams?.templateType) {
        case TemplateType.Favorite:
          if (createSchedule) {
            addNewRemider();
          } else {
            editFavorite();
          }
          break;
        case TemplateType.Reminder:
          if (!createSchedule) {
            addNewFavorite();
          } else {
            editRemider();
          }
          break;
        default:
          break;
      }
    }
  }

  @override
  void onTap(String? typeField, String? value, {bool isAmountWidget = false}) {
    super.onTap(typeField, value, isAmountWidget: false);
    canPay = true;
    setState(() {});
  }

  void formatReminderPerios() {
    _periodicCtrl.text = everyWeek
        ? locale.getText('period_hint_week_$reminderDay')
        : sprintf(locale.getText('period_hint_month'), [reminderDay]);
  }

  /// Добавляет новое напоминание об оплате
  void addNewRemider() {
    Map<String, dynamic> request = {};

    request["id"] = payBill?.id;

    if (everyWeek) {
      request["fireWeekDay"] = reminderDay;
    } else {
      request["fireMonthDay"] = reminderDay;
    }

    request["type"] = "USER";
    request["oneTimeReminder"] = false;
    request["name"] = paymentParams?.title;

    ReminderPresenter.addNew(
        data: jsonEncode(request),
        onSuccess: ({data}) async {
          onLoad(load: false);

          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddingTemplateResult(
                        bySchedule: true,
                      )));

          Navigator.pop(context, [TemplateEditResult.Changed, null]);
        },
        onError: (error) {
          onLoad(load: false);
          onFail(error);
        });
  }

  /// Редактирование напоминания об оплате
  void editRemider() {
    Map<String, dynamic> request = {};

    request["id"] = paymentParams?.remider?.id;
    request["billId"] = payBill?.id;

    if (everyWeek) {
      request["fireWeekDay"] = reminderDay;
    } else {
      request["fireMonthDay"] = reminderDay;
    }

    request["type"] = "USER";
    request["oneTimeReminder"] = false;
    request["name"] = templateNameField?.value;

    ReminderPresenter.edit(
        data: jsonEncode(request),
        onSuccess: ({data}) async {
          onLoad(load: false);

          Navigator.pop(context, [TemplateEditResult.Changed, data]);
        },
        onError: (error) {
          onLoad(load: false);
          onFail(error);
        });
  }

  /// Добавление нового шаблона избранного
  void addNewFavorite() => FavoritePresenter.newFavorite(
        data: {
          'billId': payBill?.id,
          'name': templateNameField?.value,
        },
        onSuccess: ({data}) async {
          onLoad(load: false);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddingTemplateResult(),
            ),
          );

          Navigator.pop(context, [TemplateEditResult.Changed, null]);
        },
        onFail: (error, errorBody) {
          onLoad(load: false);
          onFail(error);
        },
      );

  /// Редактирование шаблона избранного
  void editFavorite() => FavoritePresenter.edit(
        data: {
          'billId': payBill?.id,
          'name': templateNameField?.value,
          'favoriteId': paymentParams?.favorite?.id
        },
        onSuccess: ({data}) async {
          onLoad(load: false);

          Navigator.pop(context, [TemplateEditResult.Changed, data]);
        },
        onFail: (error, errorBody) {
          onLoad(load: false);
          onFail(error);
        },
      );

  /// Удаление шаблона [избранного/по расписанию]
  Future<void> removeTemplate() async {
    var result = await viewModalSheetDialog(
          context: context,
          title: locale.getText('del_template_title'),
          message: locale.getText('del_template_message'),
          confirmBtnTitle: locale.getText('delete'),
          confirmBtnTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorNode.Red,
          ),
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (result) {
      onLoad();

      switch (paymentParams?.templateType) {
        case TemplateType.Favorite:
          FavoritePresenter.toDelete(
            id: paymentParams?.favorite?.id,
            onDeleted: () {
              Navigator.pop(context,
                  [TemplateEditResult.Removed, paymentParams?.favorite?.id]);
            },
            onFail: (error, errorBody) {
              onLoad(load: false);
              onFail(error);
            },
          );
          break;
        case TemplateType.Reminder:
          if (paymentParams?.remider?.id != null) {
            ReminderPresenter.delete(
              paymentParams!.remider!.id!,
              onSuccess: ({data}) {
                Navigator.pop(context,
                    [TemplateEditResult.Removed, paymentParams!.remider!.id]);
              },
              onError: (error) {
                onLoad(load: false);
                onFail(error);
              },
            );
          }

          break;
        default:
          break;
      }
    }
  }
}
