import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/transfer_abroad_result_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/transfer_abroad_result_screen_model.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/widgets/transfer_abroad_details_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/transfer_details_screen_route.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/pdf.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sprintf/sprintf.dart';
import 'package:intl/intl.dart';

abstract class ITransferAbroadResultScreenWidgetModel extends IWidgetModel {
  String get amountPaid;

  String get commission;

  void openTransferDetailsBottomSheet();

  void returnToMain();

  void popBack();

  void repeatTransfer();

  void sharePaymentInfo();
}

class TransferAbroadResultScreenWidgetModel extends WidgetModel<
        TransferAbroadResultScreen, TransferAbroadResultScreenModel>
    implements ITransferAbroadResultScreenWidgetModel {
  TransferAbroadResultScreenWidgetModel(
    TransferAbroadResultScreenModel model,
    this._analyticsInteractor,
  ) : super(model);

  final AnalyticsInteractor _analyticsInteractor;

  @override
  String get amountPaid =>
      _sentAmount(widget.arguments.payment!.amountHundredths);

  @override
  String get commission =>
      _calculateCommission(widget.arguments.payment!.commission);

  late final _arguments = widget.arguments;
  late final _receiver = _arguments.receiverEntity;
  late final _fromCard = _arguments.fromCard;

  @override
  void initWidgetModel() {
    if (_arguments.resultStatus == TransferAbroadResultStatus.success) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        _analyticsInteractor.abroadTracker.trackSuccess(
          destination: _receiver.bankName,
          source: getTransferSourceTypesByInt(_fromCard.type),
          amount: _arguments.amount,
        );
      });
    }

    super.initWidgetModel();
  }

  @override
  void returnToMain() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      NavigationWidget.Tag,
      (Route<dynamic> route) => false,
    );
  }

  @override
  void popBack() {
    Navigator.of(context).popUntil(
        (route) => route.settings.name == TransferDetailsScreenRoute.Tag);
  }

  @override
  void sharePaymentInfo() async {
    final result = await saveToPDF(_paymentInfo);
    if (result != null) {
      OpenFilex.open(result);
    }
  }

  @override
  void openTransferDetailsBottomSheet() {
    TransferAbroadDetailsBottomSheet.show(
      context: context,
      countryIcon: widget.arguments.transferCountryEntity.icon,
      amountPaid: amountPaid,
      commission: commission,
      paymentInfo: _paymentInfo,
      sharePaymentInfo: sharePaymentInfo,
    );
  }

  @override
  void repeatTransfer() {
    Navigator.of(context).popUntil(
        (route) => route.settings.name == TransferDetailsScreenRoute.Tag);
  }

  Map<String, dynamic> get _paymentInfo => {
        locale.getText('datetime'):
            _formatIssuedDate(widget.arguments.payment!.date7),
        locale.getText('receiver_card'): formatCardNumberSecondary(
            widget.arguments.receiverEntity.maskedPan),
        // TODO: masking pan unless BE provides valid masked pan
        locale.getText('amount_sent_to_receiver'):
            _receivedAmount((widget.arguments.rateEntity.payAmount)),
        locale.getText('sender_card'):
            formatCardNumberSecondary(widget.arguments.fromCard.number ?? ''),
        locale.getText('amount_to_pay'): amountPaid,
        locale.getText('commission'): commission,
        locale.getText('receiver_bank_name'):
            widget.arguments.receiverEntity.bankName ??
                locale.getText('bank_card_kazakhstan'),
        locale.getText('transfer_direction'):
            widget.arguments.transferCountryEntity.country.countryName,
      };

  String _formatIssuedDate(String? issuedDate) {
    if (issuedDate == null) {
      return '';
    }
    final dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(issuedDate);
    final outputFormat = DateFormat.yMMMMd(locale.prefix);
    return "${outputFormat.format(dateTime)} ${DateFormat("HH:mm").format(dateTime)}";
  }

  String _sentAmount(double amount) => sprintf(
        locale.getText('amount_format'),
        [formatAmount(amount)],
      );

  String _receivedAmount(double amount) => sprintf(
        locale.getText('amount_format_tenge'),
        [formatAmount(amount)],
      );

  String _calculateCommission(double? commission) => (commission == null)
      ? locale.getText("no_commission")
      : sprintf(
          locale.getText("commission_amount"),
          [formatAmount(commission)],
        );
}

TransferAbroadResultScreenWidgetModel
    transferAbroadResultScreenWidgetModelFactory(_) =>
        TransferAbroadResultScreenWidgetModel(
          TransferAbroadResultScreenModel(),
          inject(),
        );
