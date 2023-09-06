import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart' show locale, db, appTheme, pref;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/attach_pynet_id_presenter.dart';
import 'package:mobile_ultra/net/payment/get_view_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/net/payment/payment_check_presenter.dart';
import 'package:mobile_ultra/net/payment/payment_presenter.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/payment_result.dart';
import 'package:mobile_ultra/screens/main/payments/payment_verification_widget.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/rows/receipt_row_item.dart';
import 'package:mobile_ultra/ui_models/various/combobox.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/title2.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

enum JField {
  None,
  Set,
  CheckAndPay,
}

// todo remove!
abstract class MakePaymentState<T extends StatefulWidget>
    extends BaseInheritedTheme<T>
    with
        PaymentCheckView,
        PaymentView,
        GetViewPresenterView,
        WidgetsBindingObserver {
  String? title;
  MerchantEntity? merchant;
  PynetId? account;
  String comment = '';

  bool isFavorite = false,
      uField = false,
      isDialogVisible = false,
      invoice = false,
      blockBtn = false,
      autoInfoRequest = false;

  JField jField = JField.None;

  PaymentType? paymentType;
  AttachedCard? currentCard;
  Bill? payBill;

  Map<String, dynamic> requestBody = {};
  Map<String, String> details = {};
  List<MerchantField> fieldList = [];
  List<String> queryParams = [];

  FocusNode? focus;

  Column dropdownFieldsContainer = Column(
    key: Key('dynamic_dropdowns'),
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[],
  );

  Column fieldsContainer = Column(
    key: Key('dynamic_fields'),
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      focus = FocusScope.of(context).focusedChild;
      focus?.unfocus();
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(Duration(milliseconds: 200), () => focus?.requestFocus());
    }
  }

  @override
  void onGetView({List<MerchantField>? newFields, String? error}) {
    setState(() => blockBtn = false);
    onShowContent();

    if (error != null) {
      onFail(error);
      return;
    }

    uField = false;
    account = null;

    makeDynamicFields(items: newFields);
  }

  @override
  void onCheckComplete({Bill? data, String? error}) {
    setState(() => blockBtn = false);

    if (error != null) {
      onShowContent();
      onFail(error);
      return;
    }

    payBill = data;

    if (payBill?.status != 0) {
      onShowContent();
      onFail(payBill?.statusMessage);
    } else {
      autoInfoRequest = false;

      switch (jField) {
        case JField.Set:
          jField = JField.CheckAndPay;
          break;
        case JField.CheckAndPay:
          onMakePay();
          return;
        default:
          jField = JField.None;
          break;
      }

      if (paymentType == PaymentType.ADD_NEW_ACCOUNT)
        attachPynetId();
      else {
        onShowContent();
        onConfirmPay();
      }
    }
  }

  @override
  void onPaid({
    Payment? payment,
    String? error,
    dynamic errorBody,
  }) async {
    onShowContent();

    dynamic payResult = payment;

    jField = JField.None;
    requestBody.clear();
    details.clear();
    fieldList.clear();
    queryParams.clear();

    if (error != null) {
      if (errorBody != null && errorBody is Map<String, dynamic>) {
        final errResp = RequestError.fromJson(errorBody);
        if (errResp.status == 400 &&
            errResp.detail == 'not_card_owner_sms_sent') {
          payResult = await Navigator.pushNamed(
              context, PaymentVerificationWidget.Tag,
              arguments: [
                payBill?.id,
                currentCard,
                PaymentVerifyType.PAYMENT,
              ]);

          if (payResult == null) return;
        } else {
          onFail(error);
          return;
        }
      } else {
        onFail(error);
        return;
      }
    }

    pref?.madePay(true);
    MainPresenter.cardsBalances();

    Navigator.pop(
      context,
      await Navigator.pushNamed(
        context,
        PaymentResultWidget.Tag,
        arguments: [payResult, merchant, payBill],
      ),
    );
  }

  void onPynetIdAttached({String? error}) {
    onShowContent();

    if (error != null) {
      onFail(error);
      return;
    }

    Future.delayed(
        Duration(milliseconds: 100), () => Navigator.pop(context, true));
  }

  Future<void> loadFields({List<MerchantField>? items}) async {
    if (items == null || items.isEmpty)
      fieldList =
          await db?.getMerchantFields(merchant?.id, locale.prefix) ?? [];
    else {
      fieldList.clear();
      fieldList.addAll(items);
    }
  }

  Future<void> makeDynamicFields({List<MerchantField>? items}) async {
    await loadFields(items: items);

    dropdownFieldsContainer = Column(
      key: Key('dynamic_dropdowns'),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );

    fieldsContainer = Column(
      key: Key('dynamic_fields'),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );

    setState(() => makeFields(makeDropdownButtons()));
  }

  List<dynamic> makeDropdownButtons() {
    var result;
    ValueNotifier<MerchantFieldValue?>? valueNotifierListener;
    MerchantFieldValue? comboboxDefaultValue;

    String? prefix;
    final dropdownFieldList = fieldList
        .where((field) => field.values?.isNotEmpty ?? false)
        .toList(growable: false);

    for (int i = 0; i < dropdownFieldList.length; i++) {
      final field = dropdownFieldList[i];

      valueNotifierListener ??= ValueNotifier(field.values?[0]);
      comboboxDefaultValue = null;

      if (account != null) {
        comboboxDefaultValue = field.values?.firstWhereOrNull((value) {
          if (value?.prefix != null)
            return account?.account?.startsWith(value!.prefix!) ?? false;
          else
            return account?.payBill?[field.typeName] == value?.fieldValue;
        });
      } else if (field.defaultValue != null) {
        comboboxDefaultValue = field.values?.firstWhere(
            (fieldValue) =>
                fieldValue?.fieldValue == field.defaultValue ||
                fieldValue?.checkId == field.defaultValue ||
                fieldValue?.prefix == field.defaultValue,
            orElse: () => null);
      } else if (queryParams.isNotEmpty) {
        var value = queryParams.firstWhereOrNull(
            (element) => element.contains('${field.type.toLowerCase()}='));

        if (value != null) {
          value = value.substring(value.indexOf('=') + 1);

          comboboxDefaultValue = field.values?.firstWhere(
              (fieldValue) =>
                  fieldValue?.fieldValue == value ||
                  fieldValue?.checkId == value ||
                  fieldValue?.prefix == value,
              orElse: () => null);
        }
      }

      final combobox = ComboBox(
        key: GlobalKey<ComboBoxState>(),
        title: field.label ?? '',
        field: field,
        onChanged: (id, prefix) {
          makeFields(['$id', null, prefix]);
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
        },
        value: comboboxDefaultValue,
        valueNotifierListener: valueNotifierListener,
      );
      valueNotifierListener = combobox.valueNotifierFire;

      result = comboboxDefaultValue != null
          ? comboboxDefaultValue.id
          : field.values?.first?.id;

      if ((field.typeName == 'PREFIX' || field.typeName == 'SERVICE_ID') &&
          field.values?.first?.prefix != null) {
        prefix =
            comboboxDefaultValue?.prefix ?? field.values?.first?.prefix ?? '';
      }

      dropdownFieldsContainer.children.add(combobox);
    }

    return ['$result', comboboxDefaultValue, prefix];
  }

  /// Creates dynamic fields. Maybe depends from dropdown field value
  /// List<dynamic> conditions:
  ///     [0] - parent id;
  ///     [1] - selected value from dropdown field or null;
  /// bool isNextFocusClick - если true по нажатию на клавиатуре на далее
  /// будет выполняться переход на следующее поле
  void makeFields(
    List<dynamic> conditions, {
    bool isNextFocusClick = true,
    bool clearAccount = true,
  }) {
    jField = JField.None;

    String parentId = conditions[0];
    MerchantFieldValue? comboboxDefaultValue = conditions[1];
    String? prefix = conditions[2];

    printLog('parentId = $parentId');

    bool rebuild = false;

    FocusNode focus = FocusNode(), nextFocus = FocusNode();

    var inputFieldList = fieldList
        .where((field) =>
            (field.values?.isEmpty ?? false) && field.parentId == parentId)
        .toList(growable: false);

    rebuild = inputFieldList.isNotEmpty;

    if (!rebuild)
      inputFieldList = fieldList
          .where((field) => field.values?.isEmpty ?? false)
          .toList(growable: false);

    if (rebuild || fieldsContainer.children.isEmpty) {
      if (rebuild)
        fieldsContainer = Column(
          key: Key('dynamic_fields'),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        );

      for (int i = 0; i < inputFieldList.length; i++) {
        final field = inputFieldList[i];

        if (paymentType == PaymentType.ADD_NEW_ACCOUNT && field.type == 'A')
          continue;

        String? defaultValue = field.defaultValue;
        if (account != null) {
          if (comboboxDefaultValue != null &&
              comboboxDefaultValue.prefix != null) {
            defaultValue = account?.payBill?[field.typeName];

            if (defaultValue != null) {
              defaultValue = defaultValue.substring(
                  comboboxDefaultValue.prefix?.length ?? 0,
                  defaultValue.length);
            }
          } else if (field.type == 'A' && account?.balanceType == 5)
            defaultValue = account?.lastBalance.toString();
          else
            defaultValue = account?.payBill?[field.typeName];
        } else if (queryParams.isNotEmpty) {
          final value = queryParams.firstWhereOrNull(
              (element) => element.contains('${field.type.toLowerCase()}='));

          if (value != null)
            defaultValue = value.substring(value.indexOf('=') + 1);
        }

        if (field.controlTypeInfo != null && field.controlTypeInfo == 'U')
          uField = true;

        field.isHidden = jField == JField.Set;

        if (field.type == 'Q') {
          field.readOnly = field.type == 'Q';
          defaultValue = '1';
        }

        fieldsContainer.children.add(DynamicField(
          key: GlobalKey<DynamicFieldState>(),
          fieldInfo: field,
          focus: focus,
          nextFocus: isNextFocusClick ? nextFocus : null,
          merchant: this.merchant,
          defaultValue: defaultValue,
          action: isNextFocusClick
              ? i < inputFieldList.length - 1
                  ? TextInputAction.next
                  : TextInputAction.done
              : TextInputAction.done,
          onTap: onTap,
        ));

        focus = nextFocus;
        nextFocus = FocusNode();

        comboboxDefaultValue = null;

        if (jField == JField.None && field.type == 'J') jField = JField.Set;
      }

      if (paymentType == PaymentType.ADD_NEW_ACCOUNT) {
        fieldsContainer.children.add(DynamicField(
          key: GlobalKey<DynamicFieldState>(),
          fieldInfo: MerchantField(
            label: locale.getText('comment'),
            type: 'my_comment',
            typeName: 'my_comment',
          ),
          action: TextInputAction.done,
          defaultValue: comment,
          merchant: this.merchant,
        ));
        //fieldsContainer.children.add(SizedBox(height: 16));
      }
    }

    if (prefix != null) {
      final fields = fieldsContainer.children.where((element) =>
          (element as DynamicField).fieldInfo?.controlType == 'PHONE');

      if (fields.isNotEmpty) {
        fields.forEach((element) {
          (element as DynamicField).phonePrefix = prefix;
        });
      }
    }

    if (clearAccount) account = null;

    if (autoInfoRequest)
      Future.delayed(Duration(milliseconds: 250), () => onAttemptMakePay());
  }

  /// int checkTo - индекс поля до которого нужно проверять заполнение полей,
  /// может быть null. Если null то проверяются все поля
  void onAttemptMakePay({int? checkTo}) async {
    if (paymentType == PaymentType.MAKE_PAY && currentCard == null) return;

    if (paymentType == PaymentType.MAKE_PAY && currentCard != null) {
      if (!(currentCard?.sms ?? false)) {
        // ставиться в false, чтобы при закрытии сообщения форма не закрылась,
        // т.к. при оплате через qr/bard code автоматически выполняется инфо.запрос и в случае получения
        // ошибки с бэка форма оплаты закрывается после нажатия на "ок" в сообщении.
        autoInfoRequest = false;
        onFail(locale.getText('sms_inform_inactive'));
        return;
      } else if (currentCard?.status != CardStatus.VALID) {
        autoInfoRequest = false;
        onFail(getCardStatusDescription(currentCard));
        return;
      }
    }

    payBill = null;
    invoice = false;
    //autoInfoRequest = false;

    if (jField == JField.CheckAndPay) jField = JField.Set;

    var allowDoNext = true;

    final List<Widget> fields = fieldsContainer.children
        .where((child) => child is DynamicField)
        .toList();

    final int length = checkTo ?? fields.length;

    int index = 0;
    do {
      final field = fields[index] as DynamicField;

      if (index == 0) invoice = field.fieldInfo?.type == 'I';

      if (field.fieldInfo?.type != 'my_comment' &&
          !(field.fieldInfo?.isHidden ?? false)) {
        final invalidate = field.key?.currentState?.invalidate;

        if (invalidate != null) {
          allowDoNext = !invalidate;
        }
      }

      index++;
    } while (allowDoNext && index < length);

    if (!allowDoNext) return;

    setState(() => blockBtn = true);
    FocusScope.of(context).focusedChild?.unfocus();
    onShowLoading(locale.getText('processing_data'));

    if (uField) {
      GetViewPresenter(this).getNewView(await getRequestData);
      return;
    }

    onFirstMakeCheck(invoice, await getRequestData);
  }

  void onFirstMakeCheck(bool checkPrepaid, String requestData) {
    if (checkPrepaid)
      PaymentCheckPresenter.checkPrepaid(this).makeRequest(requestData);
    else
      PaymentCheckPresenter.check(this).makeRequest(requestData);
  }

  /// Подтверждение оплаты
  void onConfirmPay() async {
    final scrollController = ScrollController();

    final Column details = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );

    Map<String, dynamic>? detailsJson;
    Map<String, dynamic>? selectJson;

    try {
      detailsJson = jsonDecode(payBill?.responseJson ?? '{}')['details'];
      selectJson = detailsJson?.remove('select');
    } on Exception catch (ex) {
      printLog('responseJson[\'details\'] is null or empty,' +
          ' or jsonResponse contain string like {response}, or jsonResponse is null');
      printLog(ex.toString());
    }

    if (jField == JField.CheckAndPay) {
      if (detailsJson != null && detailsJson.isNotEmpty) {
        switch (merchant?.id) {
          case 7289:
            requestBody['params']['amount'] = detailsJson['amount']['value'];
            requestBody['amount'] = requestBody['params']['amount'];
            break;
          default:
            detailsJson.forEach((key, value) {
              if (requestBody.containsKey(key))
                requestBody[key] = value['value'];

              final Map<String, dynamic> params = requestBody['params'];
              if (params.containsKey(key)) {
                params[key] = value['value'];

                final field = fieldList
                    .firstWhereOrNull((element) => element.typeName == key);

                FontWeight? weight;
                if (field != null && field.type == 'A')
                  weight = FontWeight.bold;

                try {
                  details.children.add(ReceiptItem(
                    label: value['label'],
                    value: weight == null
                        ? value['value']
                        : formatAmount(double.parse(value['value'] ?? '0')),
                    labelWeight: weight,
                    valueWeight: weight,
                  ));
                } on Exception catch (ex) {
                  printLog('print main info exception: ${ex.toString()}');
                }
              }
            });
            break;
        }
      }
    } else {
      this.details.forEach((key, value) {
        final field =
            fieldList.firstWhereOrNull((element) => element.label == key);

        FontWeight? weight;
        if (field != null && field.type == 'A') weight = FontWeight.bold;

        try {
          //if (key != 'select') {
          details.children.add(ReceiptItem(
            label: key,
            value: weight == null
                ? value

                /// TODO разобраться с парсингом
                : formatAmount(double.parse(value)),
            labelWeight: weight,
            valueWeight: weight,
          ));
          //}
        } on Exception catch (ex) {
          printLog('print main info exception: ${ex.toString()}');
        }
      });

      if (invoice && detailsJson != null && detailsJson.isNotEmpty) {
        try {
          final Map<String, dynamic> amountJson = detailsJson['amount'];
          details.children.add(ReceiptItem(
            label: amountJson['label'],
            value: formatAmount(double.parse(amountJson['value'] ?? '0')),
            labelWeight: FontWeight.bold,
            valueWeight: FontWeight.bold,
          ));
        } on Exception catch (ex) {
          printLog('Print invoice amount raise exception: ${ex.toString()}');
        }
      }
    }

    if (merchant?.printInfoCheque == 1) {
      Column addition = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[],
      );

      if (detailsJson != null && detailsJson.isNotEmpty) {
        //if (merchant.id == 3469 || merchant.id == 6070) {
        if (selectJson != null) {
          try {
            List<dynamic> options = jsonDecode(selectJson['value'])['options'];

            final String selected = requestBody['params']['select'];

            final optionValue = options.firstWhere(
                (element) => element['value'] == selected,
                orElse: () => null);

            if (optionValue != null) {
              addition.children.add(ReceiptItem(
                label: 'address',
                value: optionValue['name'],
              ));
              addition.children.add(ReceiptItem(
                label: 'balance',
                value: formatAmount(double.parse(
                    optionValue['balance']?.replaceAll(',', '.') ?? '0')),
                color: optionValue['balance'].toString().startsWith('-')
                    ? ColorNode.Red
                    : ColorNode.Green,
              ));
            }
          } on Object catch (ex) {
            printLog(
                'GNK address and balance parse exception: ${ex.toString()}');
          }
        }

        //responseDetails.remove('select');

        detailsJson.forEach((key, value) {
          addition.children.add(
              ReceiptItem(label: value['label'], value: value['value'] ?? ''));
        });

        details.children.add(
          Theme(
            data: appTheme.copyWith(
              dividerColor: Colors.transparent,
              unselectedWidgetColor: ColorNode.Gray,
              accentColor: ColorNode.Gray,
            ),
            child: ExpansionTile(
              title: TextLocale(
                'show_details',
                style: TextStyle(color: Colors.black),
              ),
              children: [addition],
              onExpansionChanged: (isExpanded) {
                if (isExpanded) {
                  scrollController.animateTo(details.children.length * 50.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
            ),
          ),
        );
      }
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor:
                    (pref?.isAcceptPhoneScaleFactore ?? false) ? null : 1.0,
              ),
              child: Container(
                height: 500,
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Title2(
                          text: 'payment',
                          padding: const EdgeInsets.only(top: 24),
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 79),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 80),
                        child: details,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RoundedButton(
                        margin: const EdgeInsets.all(16),
                        title: 'make_pay',
                        onPressed: () {
                          Navigator.pop(context);

                          Future.delayed(Duration(milliseconds: 200), () {
                            onShowLoading(locale.getText('making_pay'));
                            if (jField == JField.CheckAndPay)
                              onFirstMakeCheck(false, jsonEncode(requestBody));
                            else
                              onMakePay();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))));
  }

  void onMakePay() {
    Map<String, dynamic> requestBody = {
      'billId': payBill?.id,
      'token': currentCard?.token,
      'cardType': currentCard?.type
    };

    if (currentCard?.type == 4)
      PaymentPresenter.fromHumo(this).pay(requestBody);
    else
      PaymentPresenter.fromUzcard(this).pay(requestBody);
  }

  /// Закрепление лицевого счёта
  void attachPynetId() {
    if (payBill?.id == null) {
      return;
    }

    AttachPynetIdPresenter.attach(
      payBill!.id!,
      comment: comment,
      onAttachEvent: (error) {
        onShowContent();

        if (error != null) {
          onFail(error);
          return;
        }

        Future.delayed(
          Duration(milliseconds: 100),
          () => Navigator.pop(context, true),
        );
      },
    );
  }

  /// Билд данных запроса
  Future<String> get getRequestData async {
    requestBody.clear();
    Map<String, dynamic> params = {};

    var prefix;
    var infoServiceId;
    var paymentServiceId;

    dropdownFieldsContainer.children.forEach((child) {
      final field = child as ComboBox;

      if (field.field?.type == 'C')
        requestBody['account'] = field.value?.fieldValue;

      if (!requestBody.containsKey('account') && !(field.field?.type == 'P'))
        requestBody['account'] = field.value?.fieldValue;

      if (!requestBody.containsKey('amount') &&
          field.field?.typeName == 'SERVICE_ID')
        requestBody['amount'] = field.value?.amount;

      if (field.field?.typeName == 'PREFIX' ||
          field.field?.typeName == 'SERVICE_ID') {
        prefix = field.value?.prefix;

        if (field.field?.typeName == 'SERVICE_ID') {
          infoServiceId = field.value?.checkId;
          paymentServiceId = field.value?.fieldValue;
        }
      }

      final label = field.field?.label;

      if (label != null) {
        details[label] = field.value?.label ?? '';
      }

      final typeName = field.field?.typeName;

      if (typeName == null) {
        params[typeName!] = field.value?.fieldValue ?? '';
      }
    });

    fieldsContainer.children.forEach((child) {
      if (child is DynamicField) {
        //final field = child as DynamicField;

        final label = child.fieldInfo?.label;

        if (label != null) {
          details[label] = child.value;
        }

        final typeName = child.fieldInfo?.typeName;

        if (typeName != null) {
          params[typeName] =
              prefix == null ? child.value : '$prefix${child.value}';
        }

        prefix = null;

        if (child.fieldInfo?.type == 'C' || child.fieldInfo?.type == 'I') {
          requestBody['account'] = params[typeName];
          if (child.fieldInfo?.type == 'I') requestBody['amount'] = 0;
        } else if (child.fieldInfo?.type == 'A') {
          requestBody['amount'] = params[typeName];
        } else if (child.fieldInfo?.type == 'Q') {
          if (typeName != null) {
            params[typeName] = '1';
          }
        }
      }
    });

    requestBody['merchantId'] = merchant?.id;
    requestBody['merchantName'] = merchant?.name;

    /// JField
    if (params.containsKey('amount') && params['amount'] == '')
      params['amount'] = 0;

    if (params.containsKey('pay_amount') && params['pay_amount'] == '')
      params['pay_amount'] = 0;

    /// JField

    params.removeWhere((key, value) => value == null);
    requestBody['params'] = params;

    requestBody['checkId'] = merchant?.infoServiceId ?? infoServiceId;
    requestBody['payId'] = merchant?.paymentServiceId ?? paymentServiceId;

    if (paymentType == PaymentType.ADD_NEW_ACCOUNT) {
      comment = params['my_comment'];
      requestBody['amount'] = merchant?.minAmount.toInt();
      params.removeWhere((key, value) => key == 'my_comment');
    }

    /// JField
    if (requestBody.containsKey('amount') && requestBody['amount'] == '')
      requestBody['amount'] = 0;

    requestBody.removeWhere((key, value) => value == null);

    return jsonEncode(requestBody);
  }

  void onFail(String? error) async {
    final closeIt = await showDialog(
          context: context,
          builder: (BuildContext context) => showMessage(
            context,
            locale.getText('error'),
            error ?? '',
            onSuccess: () => Navigator.pop(
              context,
              autoInfoRequest,
            ),
          ),
        ) ??
        autoInfoRequest;

    autoInfoRequest = false;

    if (closeIt) Navigator.pop(context);
  }

  void onShowContent() {
    if (isDialogVisible) Navigator.pop(context, false);
  }

  void onShowLoading(String message) async {
    isDialogVisible = true;
    isDialogVisible = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => showProgressMessage(
            context,
            locale.getText('attention'),
            message,
          ),
        ) ??
        false;
  }

  void onTap(String? typeField, String? value, {bool isAmountWidget = false}) {}
}
