import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/history/modal/history.dart' as h;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:mobile_ultra/utils/u.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;
class CardPaymentDetail extends StatefulWidget {
  final bool hasShareIcon;
  final bool hasQr;
  final h.HistoryResponse? historyItem;
  final VoidCallback? shareOnTap;

  const CardPaymentDetail({
    Key? key,
    this.hasShareIcon = false,
    this.hasQr = false,
    this.historyItem,
    this.shareOnTap,
  }) : super(key: key);

  @override
  _CardPaymentDetailState createState() => _CardPaymentDetailState();
}

class _CardPaymentDetailState extends State<CardPaymentDetail> {
  DateTime? _transactionDate;
  DateFormat outputFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
  late Map<String, dynamic> receipt;

  @override
  void initState() {
    super.initState();
    try {
      receipt = jsonDecode(widget.historyItem?.paynetReceipt ?? '{}');
    } on Object catch (_) {
      receipt = {};
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _transactionDate = widget.historyItem?.date7 == null
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parseUTC(widget.historyItem!.date7!);
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
                  widget.historyItem?.tranType == TranType.debit.value
                      ? 'show_details'
                      : 'show_transfer_details'),
              hasIcon: widget.hasShareIcon,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (widget.historyItem?.id != null) ...[
                  listViewItem(locale.getText("transaction_id"),
                      "${widget.historyItem?.id}"),
                ],
                if (receipt.isNotEmpty &&
                    receipt['details'] != null &&
                    receipt['details']['transaction_id'] != null) ...[
                  listViewItem(locale.getText('check_number'),
                      receipt['details']['transaction_id']['value'])
                ],
                listViewItem(locale.getText('service'), _merchantName),
                if (widget.historyItem?.account != null) ...[
                  listViewItem(locale.getText('account'),
                      "${widget.historyItem?.account}"),
                ],
                //when status is CREDIT, there is no pan2, but the pan is receiver
                if (widget.historyItem?.tranType == TranType.credit.value &&
                    widget.historyItem?.pan2 == null) ...[
                  listViewItem(
                      locale.getText('receiver'), "${widget.historyItem?.pan}")
                ] else ...[
                  listViewItem(
                      locale.getText('sender'), "${widget.historyItem?.pan}")
                ],
                if (widget.historyItem?.pan2 != null) ...[
                  listViewItem(locale.getText('receiver'),
                      "${widget.historyItem?.pan2}"),
                ],
                if (widget.historyItem?.fio != null) ...[
                  listViewItem(locale.getText('receiver_fio'),
                      "${widget.historyItem?.fio}"),
                ],
                if (widget.historyItem?.amountCredit != null) ...[
                  listViewItem(
                      locale.getText('receiver_gets'),
                      sprintf(
                        locale.getText('sum_with_amount'),
                        [
                          formatAmount(
                              (widget.historyItem?.amountCredit?.toDouble() ??
                                      0) /
                                  100)
                        ],
                      )),
                ],
                if (widget.historyItem?.commission != null) ...[
                  listViewItem(
                      locale.getText('commission'),
                      sprintf(
                        locale.getText('sum_with_amount'),
                        [
                          formatAmount(
                              (widget.historyItem?.commission?.toDouble() ??
                                      0) /
                                  100)
                        ],
                      )),
                ],
                listViewItem(
                    locale.getText('amount'),
                    sprintf(
                      locale.getText('sum_with_amount'),
                      [
                        formatAmount(
                            (widget.historyItem?.amount?.toDouble() ?? 0) / 100)
                      ],
                    )),
                if (_transactionDate != null)
                  listViewItem(locale.getText("datetime"),
                      "${outputFormat.format(_transactionDate!)}")
              ],
            ),
            SizedBox(height: 24),
            Visibility(
              visible: widget.hasQr,
              child: Material(
                color: ColorNode.Background,
                child: InkWell(
                  onTap: () async {
                    final url =
                        widget.historyItem?.mobileQrDto?.qrCodeUrl ?? '';
                    openBrowserURL(url: url);
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: ColorNode.Background,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: QrImage(
                      data: widget.historyItem?.mobileQrDto?.qrCodeUrl ?? '',
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
                "$title",
                style: uikit.Typographies.caption1Secondary,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "$value",
                textAlign: TextAlign.end,
                style: uikit.Typographies.textRegular,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget header({required String title, bool hasIcon = false}) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: uikit.Typographies.headline,
            ),
          ),
          GestureDetector(
            onTap: widget.shareOnTap,
            child: Row(
              children: [
                Text(
                  locale.getText('download'),
                  style:uikit.Typographies.textRegularAccent,
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
      ),
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
          style: uikit.Typographies.caption1Secondary,
        ),
        Text(
          value,
          style: uikit.Typographies.textRegular,
        ),
      ],
    );
  }

  Future openBrowserURL({
    required String url,
  }) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
      );
    }
  }

  bool get _isMerchantNameEmpty {
    if (widget.historyItem?.merchantName != null &&
        widget.historyItem!.merchantName!.isEmpty &&
        widget.historyItem?.status == TranType.ok.value &&
        widget.historyItem?.tranType == TranType.credit.value) {
      return true;
    }
    return false;
  }

  String get _merchantName {
    if (_isMerchantNameEmpty) {
      return locale.getText('money_transfer');
    }
    return widget.historyItem?.merchantName ?? '';
  }
}
