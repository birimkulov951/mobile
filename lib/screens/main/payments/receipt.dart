import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/payment/model/payment_qr.dart';
import 'package:mobile_ultra/screens/base/base_payment_result.dart';
import 'package:mobile_ultra/ui_models/rows/receipt_row_item.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/pdf.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:open_filex/open_filex.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Форма чека
// todo remove!
class ReceiptWidget extends StatefulWidget {
  static const Tag = '/paymentDetails';

  @override
  State<StatefulWidget> createState() => ReceiptWidgetState();
}

class ReceiptWidgetState extends BasePaymentResultState<ReceiptWidget> {
  @override
  String getTitleKey() => 'details';

  @override
  Widget getReceiptInfo() {
    final result = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );

    Map<String, dynamic> receipt = {};
    try {
      receipt = jsonDecode(transaction.paynetReceipt ?? '{}');
    } on Object catch (_) {}

    if (receipt.isNotEmpty) {
      final Map<String, dynamic> details = receipt['details'];

      details.remove('select');

      details.forEach((key, value) {
        result.children.add(
          ReceiptItem(
            label: value['label'],
            value: value['value'] ?? '',
            onCopied: onCopied,
          ),
        );
      });

      if (transaction.mobileQrDto != null)
        renderQR(result, transaction.mobileQrDto);
    } else {
      result.children.add(ReceiptItem(
          label: 'service',
          value: transaction.merchantName,
          onCopied: onCopied));
      result.children.add(ReceiptItem(
          label: 'payment_time',
          value: dateFormat(transaction.issuedDate),
          onCopied: onCopied));
      result.children.add(ReceiptItem(
          label: 'payment_numb',
          value: '${transaction.id ?? ''}',
          onCopied: onCopied));
      result.children.add(ReceiptItem(
          label: transaction.tranType == TranType.debit.value
              ? 'payment_from_card'
              : 'payment_to_card',
          value: formatCardNumber(transaction.pan),
          onCopied: onCopied));
      result.children.add(ReceiptItem(
          label: 'payment_amount',
          value: formatAmount(transaction.amount),
          onCopied: onCopied));

      if (transaction.mobileQrDto != null)
        renderQR(result, transaction.mobileQrDto);
    }

    result.children.add(ReceiptItem(
      label: 'payment_status',
      value: locale.getText(transaction.isSuccess ? 'trans_ok' : "trans_fail"),
      color: transaction.isSuccess ? ColorNode.Green : ColorNode.Red,
    ));

    return result;
  }

  void renderQR(final Column column, final PaymentQr mobileQrDto) {
    printLog(transaction.mobileQrDto);

    column.children.add(
      ReceiptItem(
        label: "uzpaynet_comission",
        value: mobileQrDto.pynetComission.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "with_nds",
        value: mobileQrDto.vat.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "total_to_pay",
        value: mobileQrDto.totalAmount.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "payment_type",
        value: mobileQrDto.paymentType,
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "cash",
        value: mobileQrDto.cash.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "plastik",
        value: mobileQrDto.card.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "remains",
        value: mobileQrDto.remains.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "fm_number",
        value: mobileQrDto.terminalId.toString(),
        onCopied: onCopied,
      ),
    );
    column.children.add(
      ReceiptItem(
        label: "fiscal_sign",
        value: mobileQrDto.fiscalSign,
        onCopied: onCopied,
      ),
    );
    column.children.add(InkWell(
      onTap: () {
        if (mobileQrDto.qrCodeUrl != null) {
          UrlLauncher.launchUrl(mobileQrDto.qrCodeUrl!);
        }
      },
      child: Container(
        width: 200,
        height: 200,
        child: QrImage(
          data: mobileQrDto.qrCodeUrl ?? '',
        ),
      ),
    ));
  }

  @override
  onSaveCheck() async {
    final Map<String, dynamic> toSave = {};

    Map<String, dynamic> receipt = {};
    try {
      receipt = jsonDecode(transaction.paynetReceipt ?? '{}');
    } on Object catch (_) {}

    if (receipt.isNotEmpty) {
      final Map<String, dynamic> details =
          jsonDecode(transaction.paynetReceipt)['details'];
      details.remove('select');
      details.forEach((key, value) {
        toSave[value['label']] = value['value'] ?? '';
      });

      if (transaction.mobileQrDto != null)
        _toSaveRenderQR(toSave, transaction.mobileQrDto);
    } else {
      toSave[locale.getText('service')] = transaction.merchantName;
      toSave[locale.getText('payment_time')] = dateFormat(transaction.issuedDate);
      toSave[locale.getText('payment_numb')] = '${transaction.id ?? ''}';
      toSave[locale.getText(transaction.tranType == TranType.debit.value
          ? 'payment_from_card'
          : 'payment_to_card')] = formatCardNumber(transaction.pan);
      toSave[locale.getText('payment_amount')] =
          formatAmount(transaction.amount);

      if (transaction.mobileQrDto != null)
        _toSaveRenderQR(toSave, transaction.mobileQrDto);
    }

    toSave[locale.getText('payment_status')] =
        locale.getText(transaction.isSuccess ? 'trans_ok' : "trans_fail");

    final String? result =
        await saveToPDF(toSave, merchantId: transaction.merchantHash);
    if (result != null)
      OpenFilex.open(result);
    else
      onShowMessage(
          locale.getText('error'), locale.getText('save_receipt_to_pdf_error'));
  }

  void _toSaveRenderQR(
      Map<String, dynamic> toSave, final PaymentQr mobileQrDto) {
    toSave[locale.getText('uzpaynet_comission')] =
        mobileQrDto.pynetComission.toString();
    toSave[locale.getText('with_nds')] = mobileQrDto.vat.toString();
    toSave[locale.getText('total_to_pay')] = mobileQrDto.totalAmount.toString();
    toSave[locale.getText('payment_type')] = mobileQrDto.paymentType;
    toSave[locale.getText('cash')] = mobileQrDto.cash.toString();
    toSave[locale.getText('plastik')] = mobileQrDto.card.toString();
    toSave[locale.getText('remains')] = mobileQrDto.remains.toString();
    toSave[locale.getText('fm_number')] = mobileQrDto.terminalId.toString();
    toSave[locale.getText('fiscal_sign')] = mobileQrDto.fiscalSign;
    toSave['qr'] = mobileQrDto.qrCodeUrl;
  }
}
