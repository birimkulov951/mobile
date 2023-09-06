import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_ultra/data/storages/preference.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart' show db, homeData, locale, screenHeight;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/get_view_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/net/payment/payment_check_presenter.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/card/v2/all_cards_for_payment_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payinfo_result_page.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/fields/dynamic_field.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/combobox.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/card_select.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _minPayAmountInSom = 500;
const _maxPayAmountInSom = 1000000;

enum JField {
  None,
  Set,
  CheckAndPay,
}

const _paymentByRequisiteMerchantId = 6710;

abstract class BasePaymentPageState<T extends StatefulWidget>
    extends BaseInheritedTheme<T>
    with PaymentCheckView, GetViewPresenterView, WidgetsBindingObserver {
  final Preference preference = inject<Preference>();
  PaymentParams? paymentParams;
  PynetId? account;
  DynamicField? templateNameField;

  bool isFavorite = false;
  bool uField = false;
  bool isDialogVisible = false;
  bool invoice = false;
  bool blockBtn = false;
  bool canPay = false;
  bool autoInfoRequest = false;

  JField jField = JField.None;

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

  DynamicField? amountWidget;

  bool isScrolledForm = false;
  int dropdownFieldCount = 0;
  int visibleFieldCount = 0;

  String get buttonTitle;

  bool get enabledFields;

  Color get fieldsLayoutBackgroundColor => Colors.white;

  Color? get fieldBackgroundColor => null;

  double _freeSpace = screenHeight;

  bool keyboardVisible = false;

  // SwitchContainer
  bool _hasPrev = false;
  bool _hasNext = false;
  bool _showButton = false;
  bool _showSwitchers = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    account = paymentParams?.account;
    autoInfoRequest = paymentParams?.startFromInforRequest ?? false;

    if (paymentParams?.deeplink != null) {
      queryParams.addAll(paymentParams?.deeplink?.split('&') ?? []);
    }
    _checkUserSetCardDefault();
  }

  //TODO (Abdurahmon): redo via elementary in the future
  void _checkUserSetCardDefault() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final paynetLocalStorage = await inject<Box>();
      final pickedCardId = await paynetLocalStorage.get('card_id');
      currentCard = homeData?.cards.firstWhereOrNull((card) {
        return card.id == pickedCardId;
      });
      printLog("check user cart $currentCard");
      if (currentCard != null) {
        setState(() {});
      }
    });
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
      Future.delayed(
        const Duration(milliseconds: 200),
        () => focus?.requestFocus(),
      );
    }
  }

  String getLogin() {
    return preference.loginedAccount.isNotEmpty
        ? preference.loginedAccount
        : preference.getLogin;
  }

  /// Gets new field from API
  @override
  void onGetView({List<MerchantField>? newFields, String? error}) {
    onLoad(load: false);

    if (error != null) {
      onFail(error);
      return;
    }

    uField = false;
    account = null;

    if (newFields != null &&
        paymentParams?.merchant?.id == _paymentByRequisiteMerchantId) {
      newFields.removeWhere((element) => element.typeName == 'phone');
    }

    makeDynamicFields(items: newFields);
  }

  /// Info request result
  @override
  void onCheckComplete({Bill? data, String? error}) async {
    onLoad(load: false);

    if (error != null) {
      onFail(error);
      return;
    }

    payBill = data;

    if (payBill?.status != 0) {
      onFail(payBill?.statusMessage);
    } else {
      autoInfoRequest = false;

      switch (jField) {
        case JField.Set:
          jField = JField.CheckAndPay;
          break;
        default:
          jField = JField.None;
          break;
      }

      AnalyticsInteractor.instance.paymentTracker.trackConfirmed(
        source: getTransferSourceTypesByInt(currentCard?.type),
        merchantId: data?.merchantId,
        amount: data?.amount,
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayinfoResultPage(
            isScrolled: isScrolledForm,
            paymentParams: paymentParams,
            payBill: data,
            jField: jField,
            details: details,
            fieldList: fieldList,
            invoice: invoice,
            requestBody: requestBody,
            selectedCard: currentCard,
          ),
        ),
      );

      if (result != null) {
        Navigator.pop(context, result);
      }
    }
  }

  @override
  void onGetFreeSpace({bool init = true, double freeSpace = 0}) {
    if (init || _freeSpace == freeSpace) {
      return;
    }
    setState(() {
      if (keyboardVisible) {
        _freeSpace = freeSpace;
      } else {
        _freeSpace = freeSpace + MediaQuery.of(context).viewPadding.bottom;
      }
      printLog('onGetFreeSpace: $_freeSpace');
    });
  }

  Widget get scrolledForm {
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                key: topContainerKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ItemContainer(
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: 24,
                      ),
                      backgroundColor: fieldsLayoutBackgroundColor,
                      child: Column(
                        children: [
                          ProviderItem(
                            merchant: paymentParams?.merchant,
                          ),
                          templateNameField ?? const SizedBox(),
                          dropdownFieldsContainer,
                          fieldsContainer,
                        ],
                      ),
                    ),
                    cardLayout,
                    additionLayout,
                  ],
                ),
              ),
              SizedBox(height: 12),
              buttonLayout,
            ],
          ),
        ),
        if (keyboardVisible && _showButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: ColorNode.Main,
                boxShadow: [
                  BoxShadow(
                    color: ColorNode.Background,
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_showSwitchers)
                    Row(
                      children: [
                        SizedBox(width: 4),
                        SvgPicture.asset(
                          Assets.chevronUp,
                          height: 15,
                          color: _hasPrev
                              ? ColorNode.Green
                              : ColorNode.GreyScale400,
                        ),
                        SizedBox(width: 20),
                        SvgPicture.asset(
                          Assets.chevronDown,
                          height: 15,
                          color: _hasNext
                              ? ColorNode.Green
                              : ColorNode.GreyScale400,
                        ),
                      ],
                    ),
                  if (!_showSwitchers) SizedBox.shrink(),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: TextLocale(
                      'ready',
                      style: TextStyles.captionButton.copyWith(
                        color: ColorNode.MainSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget get nonScrolledForm => Stack(
        children: [
          Column(
            children: [
              ItemContainer(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 24,
                ),
                backgroundColor: fieldsLayoutBackgroundColor,
                child: Column(
                  children: [
                    ProviderItem(
                      merchant: paymentParams?.merchant,
                    ),
                    templateNameField ?? const SizedBox(),
                    dropdownFieldsContainer,
                    fieldsContainer,
                  ],
                ),
              ),
              cardLayout,
              additionLayout,
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: buttonLayout,
          ),
        ],
      );

  Widget get cardLayout => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: TextLocale(
              'where',
              style: TextStyles.captionButton,
            ),
          ),
          SizedBox(height: 8),
          ItemContainer(
            child: currentCard == null
                ? CardSelect.card(
                    key: const Key(WidgetIds.basePaymentChangeCard),
                    onTap: () => _onTapSelectCard(currentCard),
                  )
                : CardItem(
                    key: const Key(WidgetIds.basePaymentSelectCard),
                    uCard: currentCard!,
                    margin: EdgeInsets.all(0),
                    onTap: _onTapSelectCard,
                  ),
          ),
        ],
      );

  void _onTapSelectCard(AttachedCard? card) async {
    final result = await viewModalSheet(
      context: context,
      backgroundColor: ColorNode.Background,
      child: AllCardsForPaymentPage(card: card),
    );

    if (result != null) {
      setState(() => currentCard = result);
      onChangeCurrentCard(currentCard);
      //TODO (Abdurahmon): redo via elementary in the future
      if (currentCard?.type != Const.BONUS) {
        final paynetLocalStorage = await inject<Box>();
        await paynetLocalStorage.put('card_id', currentCard?.id);
      }
    }
  }

  @protected
  void onChangeCurrentCard(AttachedCard? card) {
    amountWidget?.cashbackExists = card?.type != Const.BONUS;
    onTap(
      amountWidget?.fieldInfo?.typeName,
      amountWidget?.value.replaceAll(locale.getText('sum'), ''),
      isAmountWidget: true,
    );
  }

  Widget get additionLayout => SizedBox();

  Widget get buttonLayout => ItemContainer(
        key: bottomContainerKey,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        margin: EdgeInsets.only(
          bottom: keyboardVisible
              ? MediaQuery.of(context).viewInsets.bottom
              : MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: buttonLayoutItems,
        ),
      );

  List<Widget> get buttonLayoutItems => [
        amountWidget ?? const SizedBox(),
        RoundedButton(
          key: const Key(WidgetIds.basePaymentPayButton),
          margin: EdgeInsets.only(
            left: 16,
            top: 12,
            right: 16,
            bottom: 16,
          ),
          title: buttonTitle,
          loading: blockBtn,
          onPressed: !canPay ? null : onAttemptMakePay,
        ),
      ];

  Future<void> loadFields({List<MerchantField>? items}) async {
    if (items == null || items.isEmpty) {
      fieldList = await db?.getMerchantFields(
            paymentParams?.merchant?.id,
            locale.prefix,
          ) ??
          [];
    } else {
      fieldList.clear();
      fieldList.addAll(items);
    }
  }

  Future<void> makeDynamicFields({List<MerchantField>? items}) async {
    await loadFields(items: items);

    isScrolledForm = false;
    dropdownFieldCount = 0;
    visibleFieldCount = 0;

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

    setState(() {
      makeFields(makeDropdownButtons());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        super.didChangeDependencies();
      });
    });

    if (autoInfoRequest) {
      Future.delayed(
        const Duration(milliseconds: 250),
        () => onAttemptMakePay(),
      );
    }
  }

  List<dynamic> makeDropdownButtons() {
    var result;
    ValueNotifier<MerchantFieldValue?>? valueNotifierListener;
    MerchantFieldValue? comboboxDefaultValue;

    String? prefix;
    final dropdownFieldList = fieldList
        .where((field) => field.values?.isNotEmpty ?? false)
        .toList(growable: false);

    dropdownFieldCount = dropdownFieldList.length;

    for (final field in dropdownFieldList) {
      valueNotifierListener ??= ValueNotifier(field.values?[0]);
      comboboxDefaultValue = null;

      if (account != null) {
        comboboxDefaultValue = field.values?.firstWhereOrNull((value) {
          if (value?.prefix != null) {
            return value?.prefix != null &&
                (account?.account?.startsWith(value!.prefix!) ?? false);
          } else {
            return account?.payBill?[field.typeName] == value?.fieldValue;
          }
        });
      } else if (field.defaultValue != null) {
        comboboxDefaultValue = field.values?.firstWhereOrNull(
          (fieldValue) =>
              fieldValue?.fieldValue == field.defaultValue ||
              fieldValue?.checkId == field.defaultValue ||
              fieldValue?.prefix == field.defaultValue,
        );
      } else if (queryParams.isNotEmpty) {
        var value = queryParams.firstWhereOrNull(
          (element) => element.contains('${field.type.toLowerCase()}='),
        );

        if (value != null) {
          value = value.substring(value.indexOf('=') + 1);

          comboboxDefaultValue = field.values?.firstWhereOrNull(
            (fieldValue) =>
                fieldValue?.fieldValue == value ||
                fieldValue?.checkId == value ||
                fieldValue?.prefix == value,
          );
        }
      }

      final combobox = ComboBox(
        key: GlobalKey<ComboBoxState>(),
        title: field.label ?? '',
        field: field,
        backgroundColor: fieldBackgroundColor,
        forceBlock: !enabledFields,
        onChanged: (id, prefix) {
          setState(() {
            makeFields(['$id', null, prefix]);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              super.didChangeDependencies();
            });
          });
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
        prefix = comboboxDefaultValue?.prefix ?? field.values!.first!.prefix!;
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
    double topOffset = 0,
  }) {
    jField = JField.None;

    isScrolledForm = false;

    final String parentId = conditions[0];
    MerchantFieldValue? comboboxDefaultValue = conditions[1];
    final String? prefix = conditions[2];

    bool rebuild = false;
    FocusNode focus = FocusNode();
    FocusNode nextFocus = FocusNode();

    var inputFieldList = fieldList
        .where(
          (field) =>
              (field.values?.isEmpty ?? false) && field.parentId == parentId,
        )
        .toList(growable: false);

    rebuild = inputFieldList.isNotEmpty;
    if (!rebuild) {
      inputFieldList = fieldList
          .where((field) => field.values?.isEmpty ?? false)
          .toList(growable: false);
    }

    if (rebuild || fieldsContainer.children.isEmpty) {
      if (rebuild) {
        amountWidget = null;
        fieldsContainer = Column(
          key: Key('dynamic_fields'),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        );
      }

      visibleFieldCount = dropdownFieldCount;

      for (int i = 0; i < inputFieldList.length; i++) {
        final field = inputFieldList[i];

        String? defaultValue = field.defaultValue;

        printLog('${field.typeName}: $defaultValue');

        if (account != null) {
          if (comboboxDefaultValue != null &&
              comboboxDefaultValue.prefix != null) {
            defaultValue = account?.payBill?[field.typeName];

            if (defaultValue != null) {
              defaultValue = defaultValue.substring(
                comboboxDefaultValue.prefix?.length ?? 0,
                defaultValue.length,
              );
            }
          } else if (field.type == 'A' && account?.balanceType == 5) {
            defaultValue = account?.lastBalance.toString();
          } else {
            defaultValue = account?.payBill?[field.typeName];
          }
        } else if (queryParams.isNotEmpty) {
          final value = queryParams.firstWhereOrNull(
            (element) => element.contains('${field.type.toLowerCase()}='),
          );

          if (value != null) {
            defaultValue = value.substring(value.indexOf('=') + 1);
          }
        }

        if (field.controlTypeInfo != null && field.controlTypeInfo == 'U') {
          uField = true;
        }

        field.isHidden = jField == JField.Set;
        if (field.isHidden != null && !field.isHidden!) {
          visibleFieldCount++;
        }

        if (field.type == 'Q') {
          field.readOnly = field.type == 'Q';
          defaultValue = '1';
        }

        if (defaultValue != null && currentCard != null) {
          canPay = true;
        }

        //костыль на костылях для костелей, скука ;-)
        if (this.paymentParams?.merchant?.id == _paymentByRequisiteMerchantId &&
            field.typeName == 'amount' &&
            !(field.isRequired ?? true)) {
          continue;
        } else {
          fieldsContainer.children.add(
            DynamicField(
              key: GlobalKey<DynamicFieldState>(),
              fieldInfo: field,
              focus: focus,
              nextFocus: isNextFocusClick ? nextFocus : null,
              merchant: paymentParams?.merchant,
              defaultValue: defaultValue,
              action: isNextFocusClick
                  ? i < inputFieldList.length - 1
                      ? TextInputAction.next
                      : TextInputAction.done
                  : TextInputAction.done,
              backgroundColor: field.type != 'A' ? fieldBackgroundColor : null,
              forceBlock: !enabledFields,
              onTap: onTap,
              onCalculateFreeSpace: onCalculateFreeSpace,
              focusNodeLength: inputFieldList.length,
              focusedWidgetId: i + 1,
              updateSwitcherContainer: updateReadyButton,
              cashbackExists: currentCard?.type != Const.BONUS,
            ),
          );
        }

        focus = nextFocus;
        nextFocus = FocusNode();

        comboboxDefaultValue = null;

        switch (field.type) {
          case 'A':
          case 'J':
            if (amountWidget == null) {
              final last = fieldsContainer.children.removeLast();

              amountWidget = last is DynamicField ? last : null;
            } else if (field.type == 'A') {
              fieldsContainer.children.removeLast();
            }

            if (field.type == 'J' && jField == JField.None) {
              jField = JField.Set;
            }

            break;
        }
      }
    }

    if (prefix != null) {
      final fields = fieldsContainer.children.where(
        (field) => (field as DynamicField).fieldInfo?.controlType == 'PHONE',
      );

      if (fields.isNotEmpty) {
        fields.forEach((field) => (field as DynamicField).phonePrefix = prefix);
      }
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      onChangeCurrentCard(currentCard);
    });
  }

  /// int checkTo - индекс поля до которого нужно проверять заполнение полей,
  /// может быть null. Если null то проверяются все поля
  void onAttemptMakePay({int? checkTo}) {
    if ((paymentParams?.paymentType == PaymentType.MAKE_PAY ||
            paymentParams?.paymentType == PaymentType.PAY_BY_TEMPLATE) &&
        currentCard == null &&
        checkTo == null) {
      return;
    }

    if ((paymentParams?.paymentType == PaymentType.MAKE_PAY ||
            paymentParams?.paymentType == PaymentType.PAY_BY_TEMPLATE) &&
        currentCard != null) {
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

    if (jField == JField.CheckAndPay) {
      jField = JField.Set;
    }

    var allowDoNext = true;

    final List<Widget> fields = fieldsContainer.children
        .whereType<DynamicField>()
        .toList();

    final int length = checkTo ?? fields.length;

    int index = 0;
    do {
      final field = fields[index] as DynamicField;

      if (index == 0) {
        invoice = field.fieldInfo?.type == 'I';
      }

      if (field.fieldInfo?.type != 'unknown' &&
          !(field.fieldInfo?.isHidden ?? false)) {
        allowDoNext = !(field.key?.currentState?.invalidate ?? allowDoNext);
      }

      index++;
    } while (allowDoNext && index < length);

    if (amountWidget != null && checkTo == null && allowDoNext) {
      allowDoNext =
          !(amountWidget?.key?.currentState?.invalidate ?? allowDoNext);
    }

    if (!allowDoNext) {
      return;
    }

    FocusScope.of(context).focusedChild?.unfocus();
    onLoad();

    if (uField) {
      if (!(account != null &&
          account!.merchantId == _paymentByRequisiteMerchantId)) {
        GetViewPresenter(this).getNewView(getRequestJsonData);
        return;
      }
    }

    onFirstMakeCheck(invoice, getRequestJsonData);
  }

  void onFirstMakeCheck(bool checkPrepaid, String requestData) {
    if (checkPrepaid) {
      PaymentCheckPresenter.checkPrepaid(this).makeRequest(requestData);
    } else {
      PaymentCheckPresenter.check(this).makeRequest(requestData);
    }
  }

  String get getRequestJsonData {
    details.clear();
    requestBody.clear();
    final Map<String, dynamic> params = {};

    var prefix;
    var infoServiceId;
    var paymentServiceId;

    // Dropdown items
    dropdownFieldsContainer.children.forEach((child) {
      final field = child as ComboBox;

      if (field.field?.type == 'C') {
        requestBody['account'] = field.value?.fieldValue;
      }

      if (!requestBody.containsKey('account') && !(field.field?.type == 'P')) {
        requestBody['account'] = field.value?.fieldValue;
      }

      if (!requestBody.containsKey('amount') &&
          field.field?.typeName == 'SERVICE_ID') {
        requestBody['amount'] = field.value?.amount ?? '';
      }

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

      if (typeName != null) {
        params[typeName] = field.value?.fieldValue;
      }
    });

    // Fields
    fieldsContainer.children.forEach((child) {
      if (child is DynamicField && child.fieldInfo?.type != 'unknown') {
        final label = child.fieldInfo?.label;

        if (label != null) {
          details[label] = child.value.replaceAll(locale.getText('sum'), '');
        }

        final typeName = child.fieldInfo!.typeName;
        params[typeName] = prefix == null
            ? child.value.replaceAll(locale.getText('sum'), '')
            : '$prefix${child.value.replaceAll(locale.getText('sum'), '')}';

        prefix = null;

        switch (child.fieldInfo?.type) {
          case 'C':
          case 'I':
            requestBody['account'] = params[typeName];

            if (child.fieldInfo?.type == 'I') {
              requestBody['amount'] = 0;
            }
            break;
          case 'A':
            requestBody['amount'] = params[typeName] ?? '';
            break;
          case 'Q':
            params[typeName] = '1';
            break;
        }
      }
    });

    if (amountWidget != null) {
      final label = amountWidget?.fieldInfo?.label;
      final typeName = amountWidget?.fieldInfo?.typeName;

      if (label != null) {
        details[label] =
            amountWidget?.value.replaceAll(locale.getText('sum'), '') ?? '';
      }

      if (typeName != null) {
        params[typeName] =
            amountWidget?.value.replaceAll(locale.getText('sum'), '') ?? '';
      }

      if (amountWidget?.fieldInfo?.type == 'A') {
        requestBody['amount'] =
            amountWidget?.value.replaceAll(locale.getText('sum'), '') ?? '';
        params['amount'] = requestBody['amount'];
      }
    }

    requestBody['merchantId'] = paymentParams?.merchant?.id;
    requestBody['merchantName'] = paymentParams?.merchant?.name;

    /// JField
    if ((params.containsKey('amount') && params['amount'] == '') ||
        params['amount'] == null) params['amount'] = 0;

    if (params.containsKey('pay_amount') && params['pay_amount'] == '')
      params['pay_amount'] = 0;

    /// JField

    if (uField &&
        account != null &&
        account!.merchantId == _paymentByRequisiteMerchantId) {
      params['phone'] = getLogin();
    } else if (paymentParams?.merchant?.id == _paymentByRequisiteMerchantId &&
        !params.containsKey('params')) {
      params['phone'] = getLogin();
    }

    params.removeWhere((key, value) => value == null);
    requestBody['params'] = params;

    requestBody['checkId'] =
        paymentParams?.merchant?.infoServiceId ?? infoServiceId;
    requestBody['payId'] =
        paymentParams?.merchant?.paymentServiceId ?? paymentServiceId;

    /// JField
    if ((requestBody.containsKey('amount') && requestBody['amount'] == '') ||
        (requestBody['amount'] == null)) {
      requestBody['amount'] = 0;
    }

    requestBody.removeWhere((key, value) => value == null);

    return jsonEncode(requestBody);
  }

  void onLoad({bool load = true}) => setState(() => blockBtn = load);

  void onFail(String? error) async {
    final closeIt = await showDialog(
          context: context,
          builder: (BuildContext context) => showMessage(
            context,
            locale.getText('error'),
            error ?? '',
            onSuccess: () => Navigator.pop(context, autoInfoRequest),
          ),
        ) ??
        autoInfoRequest;

    autoInfoRequest = false;

    if (closeIt) {
      Navigator.pop(context);
    }
  }

  void onTap(String? typeField, String? value, {bool isAmountWidget = false}) {
    printLog(
      'field: $typeField value: $value amountWidgetValue: ${amountWidget?.value} isAmountWidget: $isAmountWidget',
    );

    if (currentCard == null) {
      return;
    }

    if (amountWidget != null && isAmountWidget) {
      final minAmount =
          paymentParams?.merchant?.minAmount ?? _minPayAmountInSom;
      final maxAmount =
          paymentParams?.merchant?.maxAmount ?? _maxPayAmountInSom;
      final inputAmount = amountWidget!.value.isEmpty
          ? 0
          : double.parse(
              amountWidget!.value
                  .replaceAll(locale.getText('sum'), '')
                  .replaceAll(' ', ''),
            );
      canPay = false;
      if (value != null && value.isNotEmpty && inputAmount >= minAmount) {
        if (inputAmount > maxAmount) {
          amountWidget?.key?.currentState?.invalidate;
        } else if (inputAmount > currentCard!.balance!) {
          amountWidget?.key?.currentState?.insufficientFunds;
        } else {
          canPay = true;
          amountWidget?.key?.currentState?.sufficientFunds;
        }
      } else {
        amountWidget?.key?.currentState?.sufficientFunds;
      }
    } else {
      canPay = true;
    }
    setState(() {});
  }

  void onCalculateFreeSpace() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (topContainerKey.currentContext != null ||
          bottomContainerKey.currentContext != null) {
        final topSize = topContainerKey.currentContext != null
            ? (topContainerKey.currentContext?.findRenderObject() as RenderBox?)
                ?.size
            : Size(0, 0);

        final bottomSize = bottomContainerKey.currentContext != null
            ? (bottomContainerKey.currentContext?.findRenderObject()
                    as RenderBox?)
                ?.size
            : Size(0, 0);

        if (topSize != null && bottomSize != null) {
          onGetFreeSpace(
            init: false,
            freeSpace: height - (topSize.height + bottomSize.height),
          );
        }
      }
    });
  }

  void updateReadyButton({
    bool hasPrev = false,
    bool hasNext = false,
    bool showButton = false,
    bool showSwitchers = false,
  }) =>
      setState(() {
        _hasPrev = hasPrev;
        _hasNext = hasNext;
        _showButton = false; // false - hides ready button
        _showSwitchers = showSwitchers;
      });
}
