import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:intl/intl.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart' as p;

class PaymentDetail extends StatefulWidget {
  final bool hasShareIcon;
  final bool hasQr;
  final p.Payment? payment;
  final VoidCallback? shareOnTap;

  const PaymentDetail({
    Key? key,
    this.hasShareIcon = false,
    this.hasQr = false,
    this.payment,
    this.shareOnTap,
  }) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  DateTime? _transactionDate;
  DateFormat outputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  late Map<String, dynamic> receipt;

  @override
  void initState() {
    super.initState();
    try {
      receipt = jsonDecode(widget.payment?.paynetReceipt ?? '{}');
    } on Object catch (_) {
      receipt = {};
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _transactionDate = widget.payment?.date7 == null
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parseUTC(widget.payment!.date7!);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
          color: ColorNode.ContainerColor,
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 28,
          top: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            header(
              title: locale.getText(
                  widget.payment?.tranType == TranType.debit.value
                      ? 'show_details'
                      : 'show_transfer_details'),
              hasIcon: widget.hasShareIcon,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (widget.payment?.id != null) ...[
                  listViewItem(locale.getText("transaction_id"),
                      "${widget.payment?.id}"),
                ],
                if (receipt.isNotEmpty &&
                    receipt['details'] != null &&
                    receipt['details']['transaction_id'] != null) ...[
                  listViewItem(locale.getText('check_number'),
                      receipt['details']['transaction_id']['value'])
                ],
                listViewItem(locale.getText('service'), _merchantName),
                if (widget.payment?.account != null) ...[
                  listViewItem(
                      locale.getText('account'), "${widget.payment?.account}"),
                ],
                //when status is CREDIT, there is no pan2, but the pan is receiver
                if (widget.payment?.tranType == TranType.credit.value &&
                    widget.payment?.pan2 == null) ...[
                  listViewItem(
                      locale.getText('receiver'), "${widget.payment?.pan}")
                ] else ...[
                  listViewItem(
                      locale.getText('sender'), "${widget.payment?.pan}")
                ],
                if (widget.payment?.pan2 != null &&
                    widget.payment?.pan2 != '') ...[
                  listViewItem(
                      locale.getText('receiver'), "${widget.payment?.pan2}"),
                ],
                if (widget.payment?.fio != null) ...[
                  listViewItem(
                      locale.getText('receiver_fio'), "${widget.payment?.fio}"),
                ],
                if (widget.payment?.amountCredit != null) ...[
                  listViewItem(
                    locale.getText('receiver_gets'),
                    sprintf(
                      locale.getText('sum_with_amount'),
                      [
                        formatAmount(
                            (widget.payment?.amountCredit?.toDouble() ?? 0) /
                                100)
                      ],
                    ),
                  ),
                ],
                if (widget.payment?.commission != null) ...[
                  listViewItem(
                    locale.getText('commission'),
                    sprintf(
                      locale.getText('sum_with_amount'),
                      [
                        formatAmount(
                            (widget.payment?.commission?.toDouble() ?? 0) / 100)
                      ],
                    ),
                  ),
                ],
                listViewItem(
                  locale.getText('amount'),
                  sprintf(
                    locale.getText('sum_with_amount'),
                    [
                      formatAmount(
                          (widget.payment?.amount?.toDouble() ?? 0) / 100)
                    ],
                  ),
                ),
                if (_transactionDate != null)
                  listViewItem(locale.getText("datetime"),
                      "${outputFormat.format(_transactionDate!)}")
              ],
            ),
            SizedBox(height: 24),
            Visibility(
              visible: widget.hasQr,
              child: Material(
                color: ColorNode.ContainerColor,
                child: InkWell(
                  onTap: openBrowserURL,
                  child: Container(
                    height: 180,
                    width: 180,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorNode.Background,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: QrImage(
                      data: widget.payment?.mobileQrDto?.qrCodeUrl ?? '',
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget listViewItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyles.caption1MainSecondary,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyles.textRegular,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget header({required String title, bool hasIcon = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyles.textInputBold,
          ),
        ),
        GestureDetector(
          onTap: widget.shareOnTap,
          child: Row(
            children: [
              Text(
                locale.getText('download'),
                style: TextStyles.textRegular.copyWith(
                  color: ColorNode.Green,
                ),
              ),
              SizedBox(width: 4),
              SvgPicture.asset(
                Assets.actionDownload,
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget items({
    required String key,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: TextStyles.caption1MainSecondary,
        ),
        Text(
          value,
          style: TextStyles.textRegular,
        ),
      ],
    );
  }

  void openBrowserURL() {
    final url = widget.payment?.mobileQrDto?.qrCodeUrl ?? '';
    UrlLauncher.launchUrl(url);
  }

  bool get _isMerchantNameEmpty {
    if (widget.payment?.merchantName != null &&
        widget.payment!.merchantName!.isEmpty &&
        widget.payment?.status == TranType.ok.value &&
        widget.payment?.tranType == TranType.credit.value) {
      return true;
    }
    return false;
  }

  String get _merchantName {
    if (_isMerchantNameEmpty) {
      return locale.getText('money_transfer');
    }
    return widget.payment?.merchantName ?? '';
  }
}
