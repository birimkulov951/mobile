import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show db, locale, reminderList;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/net/payment/reminder_presenter.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/pay_by_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/template_item.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class TemplateReminderPaymentsWidget extends StatefulWidget {
  TemplateReminderPaymentsWidget(
    this.merchantRepository, {
    GlobalKey? key,
  }) : super(
          key: key,
        );

  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => TemplateReminderPaymentsWidgetState();
}

class TemplateReminderPaymentsWidgetState
    extends State<TemplateReminderPaymentsWidget> {
  bool _editableItems = false;

  @override
  void initState() {
    super.initState();
    if (reminderList.isEmpty) {
      ReminderPresenter.list(onSuccess: ({data}) => updateRemiders());
    }
  }

  @override
  Widget build(BuildContext context) =>
      reminderList.isEmpty ? _noTemplates : _listItems;

  Widget get _noTemplates => Column(
        children: [
          ItemContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.unit2,
              vertical: Dimensions.unit,
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.unit3),
                bottomRight: Radius.circular(Dimensions.unit3)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title1(
                  text: 'no_schedule_payments',
                  size: 18,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: Dimensions.unit1_5),
                Title1(
                  text: 'schedulre_payments_hint',
                  size: Dimensions.unit2,
                ),
              ],
            ),
          ),
        ],
      );

  Widget get _listItems => SizedBox(
        height: MediaQuery.of(context).size.height - 72,
        child: ListView.builder(
          itemCount: reminderList.length,
          itemBuilder: (context, index) => TemplateItem(
            key: Key('${WidgetIds.templatesPageReminderTemplateList}_$index'),
            item: reminderList[index],
            isLast: (reminderList.length - 1) == index,
            index: index,
            viewControls: _editableItems,
            templateType: TemplateType.Reminder,
            onTap: _payByTemplate,
            onDeleteItem: _attemptDeleteItem,
          ),
        ),
      );

  Future<void> _payByTemplate(int itemIndex) async {
    final reminder = reminderList[itemIndex];
    final merchant =
        widget.merchantRepository.findMerchant(reminder.merchantId);

    if (merchant == null) {
      showDialog(
          context: context,
          builder: (context) => showMessage(
              context,
              locale.getText('attention'),
              locale.getText('service_not_available'),
              onSuccess: () => Navigator.pop(context)));
      return;
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PayByTemplatePage(
                    paymentParams: PaymentParams(
                  merchant: merchant,
                  title: reminderTemplateName(reminder),
                  paymentType: PaymentType.PAY_BY_TEMPLATE,
                  account: PaynetId(
                      account: reminder.account, payBill: reminder.payBill),
                  remider: reminder,
                  templateType: TemplateType.Reminder,
                ))));

    updateRemiders();
  }

  Future<void> _attemptDeleteItem(int itemIndex) async {
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
      //onLoad();

      if (reminderList[itemIndex].id != null) {
        ReminderPresenter.delete(
          reminderList[itemIndex].id!,
          onSuccess: ({data}) => setState(() {
            reminderList.removeAt(itemIndex);
          }),
          onError: (error) => _onFail(error),
        );
      }
    }
  }

  void _onFail(String error) => showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
            context, locale.getText('error'), error,
            onSuccess: () => Navigator.pop(context)),
      );

  void updateRemiders() => setState(() {});

  void makeEditItems() => setState(() => _editableItems = !_editableItems);
}
