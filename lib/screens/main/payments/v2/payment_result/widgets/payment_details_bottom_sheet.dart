import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/net/history/modal/history_detail_data.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/history/card_detail_presenter.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/payment/model/payment_qr.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart' as h;
import 'package:intl/intl.dart';
import 'package:mobile_ultra/utils/pdf.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

import 'package:mobile_ultra/screens/main/payments/v2/payment_result/widgets/payment_detail.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/widgets/payment_details_header.dart';

class PaymentDetailsBottomSheet extends StatefulWidget {
  final bool hasShareIcon;
  final bool hasQr;
  final bool hasUserCode;
  final h.Payment? payment;

  const PaymentDetailsBottomSheet({
    Key? key,
    this.hasShareIcon = false,
    this.hasQr = false,
    this.hasUserCode = false,
    this.payment,
  }) : super(key: key);

  @override
  _PaymentDetailsBottomSheetState createState() =>
      _PaymentDetailsBottomSheetState();
}

class _PaymentDetailsBottomSheetState extends State<PaymentDetailsBottomSheet>
    with CardDetailView {
  String? receipt;
  bool identificationLoading = false;
  h.Payment? transaction;
  bool buttonActive = false;
  HistoryDetailData? historyDetailMap;
  bool empty = false;
  DateTime? data;
  var outputFormat;
  int onTapDisable = 0;

  @override
  void initState() {
    super.initState();
    data = widget.payment?.date7 == null
        ? null
        : DateFormat("yyyy-MM-ddTHH:mm:ss").parseUTC(widget.payment!.date7!);

    outputFormat = DateFormat.yMMMMd(locale.prefix);

    transaction = widget.payment;
    if (transaction != null &&
        transaction is h.Payment &&
        (transaction?.isSuccess ?? false)) {
      CardDetailPresenter(this)
          .getReceipt([widget.payment?.merchantHash ?? '-1', locale.prefix]);
    }
  }

  @override
  Widget build(BuildContext context) => identificationLoading
      ? Container(
          height: MediaQuery.of(context).size.height / 2,
          width: 200,
          child: LoadingWidget(
            showLoading: identificationLoading,
            withProgress: true,
          ),
        )
      : Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SafeArea(
            minimum: EdgeInsets.only(
              bottom: 10,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PaymentDetailsHeader(
                        id: widget.payment!.id,
                        status: widget.payment!.status!,
                        type: widget.payment!.tranType!,
                        dateTime: "${outputFormat.format(data)} "
                            "${data == null ? '' : DateFormat("HH:mm").format(data!)}",
                        price: (widget.payment?.amount ?? 0) / 100,
                        merchantId: widget.payment?.merchantHash ?? '',
                      ),
                      SizedBox(height: 4),
                      Flexible(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          padding: EdgeInsets.zero,
                          children: [
                            if (widget.payment != null)
                              PaymentDetail(
                                hasQr: widget.hasQr,
                                payment: widget.payment!,
                                hasShareIcon: widget.hasShareIcon,
                                shareOnTap: () => onSaveCheck(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 4,
                      width: 36,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: ColorNode.GreyScale400,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

  void onFail(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
        context,
        locale.getText('error'),
        message,
        onSuccess: () => Navigator.pop(context),
      ),
    );
  }

  saveReceiptToPdf(String receipt) async {
    if ((await Permission.storage.status) != PermissionStatus.granted) {
      if (!await Permission.storage.request().isGranted) return;
    }

    var htmlReceipt = utf8.decode(base64Decode(receipt)).replaceAll('�', '');

    final pynetReceipt = transaction?.pynetReceipt;

    final Map<String, dynamic>? details = pynetReceipt == null
        ? null
        : jsonDecode(transaction!.pynetReceipt!)?['details'];

    details?.forEach((key, value) {
      htmlReceipt = htmlReceipt.replaceAll('#$key#', value['value'] ?? '');
    });

    try {
      final int bodyIndex = htmlReceipt.indexOf('<body>');
      final String headerHtml = htmlReceipt.substring(0, bodyIndex);
      String bodyHtml = htmlReceipt.substring(bodyIndex, htmlReceipt.length);

      int lattice = -1;
      int secondLattice = -1;

      do {
        lattice = bodyHtml.indexOf('#');
        if (lattice != -1) {
          secondLattice =
              bodyHtml.indexOf('#', min(lattice + 1, bodyHtml.length));
          if (secondLattice != -1) {
            final snipet = bodyHtml.substring(lattice, secondLattice + 1);
            bodyHtml = bodyHtml.replaceAll(snipet, '');
          }
        }
      } while (lattice != -1 && secondLattice != -1);

      htmlReceipt = headerHtml + bodyHtml;
    } on Exception catch (e) {
      printLog('Removing empty #[key]# except: $e');
    }

    final pdf = await FlutterHtmlToPdf.convertFromHtmlContent(htmlReceipt,
        (await directoryPath) ?? '', '/${transaction?.merchantName}');

    return OpenFilex.open(pdf.path);
  }

  void onSaveCheck() async {
    final Map<String, dynamic> toSave = {};

    _populateMainDataToPdfReceipt(toSave: toSave);
    Map<String, dynamic> receipt = {};
    try {
      receipt = jsonDecode(transaction?.pynetReceipt ?? '{}');
    } on Object catch (_) {}

    if (receipt.isNotEmpty) {
      final Map<String, dynamic> details = transaction?.pynetReceipt == null
          ? null
          : jsonDecode(transaction!.pynetReceipt!)['details'];
      details.remove('select');
      details.forEach((key, value) {
        toSave[value['label']] = value['value'] ?? '';
      });
    } else {
      toSave[locale.getText('service')] =
          transaction?.merchantName != null ? transaction?.merchantName : "";
      toSave[locale.getText('payment_time')] = dateFormat(transaction?.date7);

      toSave[locale.getText('payment_amount')] = sprintf(
          locale.getText('sum_with_amount'),
          [formatAmount((transaction?.amount?.toDouble() ?? 0) / 100)]);
    }

    if (transaction?.mobileQrDto != null) {
      toSaveRenderQR(toSave, transaction!.mobileQrDto!);
    } else {
      toSave[locale.getText('payment_status')] = locale.getText(
          transaction?.status == "ERR" || transaction?.status == "ROK"
              ? "trans_fail"
              : 'trans_ok');
    }

    final String? result =
        await saveToPDF(toSave, merchantId: transaction?.merchantHash);
    if (result != null)
      OpenFilex.open(result);
    else
      onShowMessage(
          locale.getText('error'), locale.getText('save_receipt_to_pdf_error'));
  }

  void _populateMainDataToPdfReceipt({required Map<String, dynamic> toSave}) {
    if (transaction?.id != null) {
      toSave[locale.getText('transaction_id')] = transaction?.id;
    }
    if (transaction?.pan != null) {
      toSave[locale.getText('payment_from_card')] = transaction?.pan;
    }
    if (transaction?.pan2 != null &&
        transaction?.tranType != TranType.debit.value) {
      toSave[locale.getText('payment_to_card')] = transaction?.pan2;
    }
    if (transaction?.fio != null &&
        transaction?.tranType != TranType.debit.value) {
      toSave[locale.getText('receiver_fio')] = transaction?.fio;
    }
    if (transaction?.amountCredit != null &&
        transaction?.tranType != TranType.debit.value) {
      toSave[locale.getText('receiver_gets')] = sprintf(
          locale.getText('sum_with_amount'),
          [formatAmount((transaction?.amountCredit?.toDouble() ?? 0) / 100)]);
    }
    if (transaction?.commission != null &&
        transaction?.tranType != TranType.debit.value) {
      toSave[locale.getText('commission')] = sprintf(
          locale.getText('sum_with_amount'),
          [formatAmount((transaction?.commission?.toDouble() ?? 0) / 100)]);
    }
    if (transaction?.terminalId != null) {
      toSave[locale.getText('terminal_id')] = transaction?.terminalId;
    }
  }

  void toSaveRenderQR(
      Map<String, dynamic> toSave, final PaymentQr mobileQrDto) {
    toSave[locale.getText('uzpynet_comission')] =
        mobileQrDto.pynetComission.toString();
    toSave[locale.getText('with_nds')] = mobileQrDto.vat.toString();
    toSave[locale.getText('total_to_pay')] = mobileQrDto.totalAmount.toString();
    toSave[locale.getText('payment_type')] = mobileQrDto.paymentType;
    toSave[locale.getText('cash')] = mobileQrDto.cash.toString();
    toSave[locale.getText('plastik')] = mobileQrDto.card.toString();
    toSave[locale.getText('remains')] = mobileQrDto.remains.toString();
    toSave[locale.getText('fm_number')] = mobileQrDto.terminalId.toString();
    toSave[locale.getText('fiscal_sign')] = mobileQrDto.fiscalSign;
    toSave[locale.getText('payment_status')] = locale
        .getText(transaction?.isSuccess ?? false ? 'trans_ok' : "trans_fail");
    toSave['qr'] = mobileQrDto.qrCodeUrl;
  }

  @override
  void onGetPaymentReceipt({
    dynamic receipt,
    dynamic error,
  }) {
    if (receipt != null && mounted) {
      buttonActive = true;
      setState(() {
        this.receipt = receipt.receipt;
      });
    } else {
      setState(() {
        buttonActive = false;
      });
    }
  }

  void onShowMessage(String title, String text) => showDialog(
        context: context,
        builder: (context) => showMessage(context, title, text,
            onSuccess: () => Navigator.pop(context)),
      );
}
