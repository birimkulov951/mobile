import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:mobile_ultra/screens/base/base_autopayment_form.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/buttons/next_button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

enum AutoPaymentType {
  Create,
  Edit,
  FastPayment,
  FastPaymentEdit,
}

/// Создание/Редактирование автоплатежа
/// arguments:
///     Required[0] - action: create/edit;
///     Required[1] - merchant;
///     Required[2] - reminder or null

class AutoPaymentWidget extends StatefulWidget {
  static const Tag = '/autoPayment';

  @override
  State<StatefulWidget> createState() => AutoPaymentWidgetState();
}

class AutoPaymentWidgetState extends BaseAutopaymentForm<AutoPaymentWidget> {
  @override
  Widget get getUI => Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title ?? ''),
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
              actions: <Widget>[
                if (action == AutoPaymentType.Edit)
                  IconButton(
                    icon: SvGraphics.icon('delete'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => showMessage(
                              context,
                              locale.getText('attention'),
                              locale.getText('confirm_remove_autopayment'),
                              dismissTitle: locale.getText('cancel'),
                              onDismiss: () => Navigator.pop(context),
                              successTitle: locale.getText('delete'),
                              onSuccess: () {
                                Navigator.pop(context);
                                onShowLoading('');
                                //ReminderPresenter.delete(reminder.id, view: this).confirm();
                              }));
                    },
                  )
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProviderItem(merchant: merchant),
                  dropdownFieldsContainer,
                  fieldsContainer,
                  /*Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: TransferTabSwitcherWidget(
                  lTitle: locale.getText('by_schedule'),
                  rTitle: locale.getText('by_balance'),
                  onChange: (value) => onChangeScheduleType(value),
                ),
              ),*/
                  Visibility(
                      visible: action == AutoPaymentType.FastPayment,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16),
                            child: CustomTextField(
                              locale.getText('name'),
                              key: keyName,
                              action: TextInputAction.done,
                            ),
                          ),
                          Visibility(
                              visible: Platform.isIOS,
                              child: bySchedule
                                  ? Container()
                                  : NextButton(
                                      onPress: onAttemptMakePay,
                                      bottom: 5,
                                      right: 14,
                                    ))
                        ],
                      )),
                  Visibility(
                    visible: bySchedule,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 10, right: 16),
                          child: GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                              child: IgnorePointer(
                                  ignoring: false,
                                  child: CustomTextField(
                                    locale.getText('payment_date'),
                                    key: keyPeriod,
                                    enable: false,
                                  )),
                            ),
                            onTap: onSelectPeriod,
                          ),
                        ),
                        Visibility(
                            visible: Platform.isIOS &&
                                action != AutoPaymentType.Edit,
                            child: bySchedule
                                ? NextButton(
                                    onPress: onAttemptMakePay,
                                    bottom: 5,
                                    right: 14,
                                  )
                                : Container())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: Platform.isAndroid && action != AutoPaymentType.Edit,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RoundedButton(
                margin: const EdgeInsets.all(16),
                title: btnTitle ?? '',
                bg: appTheme.textTheme.bodyText2?.color ?? ColorNode.Green,
                color: appTheme.backgroundColor,
                onPressed: onAttemptMakePay,
              ),
            ),
          ),
          LoadingWidget(showLoading: showLoading),
        ],
      );
}
