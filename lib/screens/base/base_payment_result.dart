import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:convert/convert.dart' as convert;
import 'package:mobile_ultra/net/payment/model/payment_qr.dart';
import 'package:mobile_ultra/net/payment/payment_by_requisites_checker_presenter.dart';
import 'package:mobile_ultra/net/payment/payment_receipt_presenter.dart';
import 'package:mobile_ultra/net/report/model/transaction.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:utils/utils.dart';

abstract class BasePaymentResultState<T extends StatefulWidget>
    extends BaseInheritedTheme<T>
    with PaymentReceiptView, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();

  dynamic transaction;
  String? receipt;

  int steps = 0;
  double _originHeight = 0, _mainHeight = 0;
  double _receiptHeight = 0;
  bool tranUpdated = false;

  String getTitleKey();

  Widget getReceiptInfo();

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: 500),
      () => setState(() {
        _originHeight = MediaQuery.of(context).size.height - 150;
        _mainHeight = _originHeight;
        _receiptHeight = _mainHeight - 90;
      }),
    );
  }

  @override
  void onThemeChanged() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (transaction == null) {
      transaction = ModalRoute.of(context)?.settings.arguments;

      if (transaction is Transaction && transaction.isSuccess)
        Future.delayed(
            Duration(seconds: 1),
            () => PaymentReceiptPresenter(this)
                .getReceipt([transaction.merchantHash, locale.prefix]));
    }
  }

  @override
  Widget get formWidget => Scaffold(
        key: _keyScaffold,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context, true)),
          title:
              TextLocale(getTitleKey(), style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: [
            Visibility(
              visible:
                  transaction.isSuccess && transaction.merchantHash == '6710',
              child: SvGraphics.button(
                'repeat',
                color: Colors.black,
                onPressed: () {
                  final Map<String, dynamic> _details =
                      jsonDecode(transaction.paynetReceipt)['details'];

                  PaymentByRequisitesCheckerPresenter().checkStatus(
                    transactionId: _details['transaction_id']['value'],
                    onGetResult: onGetPaymentByrequisitesStatusResult,
                  );
                },
              ),
            ),
            Visibility(
              visible: transaction.paymentReceipt != null || receipt != null,
              child: SvGraphics.button(
                'kvitansiya',
                color: Colors.black,
                onPressed: checkStoragePermission,
              ),
            ),
          ],
        ),
        backgroundColor: ColorNode.receiptBg,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                child: Visibility(
                  visible: steps != 0,
                  child: Container(
                    height: 35,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvGraphics.titleButton(
                          iconName: 'check',
                          title: locale.getText('save_receipt'),
                          onPressed: onSaveCheck,
                        ),
                        FutureBuilder<bool>(
                            future: Utils.sunMIPrinterState,
                            initialData: false,
                            builder: (context, data) {
                              if (data.hasData && (data.data ?? false)) {
                                return RoundedButton(
                                  icon: Icon(
                                    Icons.print,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    Utils.printReceipt(await getDataToPrint());
                                  },
                                  title: 'print_receipt',
                                  color: Colors.grey,
                                  bg: Colors.transparent,
                                );
                              } else
                                return Container();
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: steps > 2 ? 1 : 300),
              onEnd: () {
                if (steps > 2) return;

                Future.delayed(
                    Duration(milliseconds: 200),
                    () => setState(() {
                          switch (steps) {
                            case 0:
                              _mainHeight -= 100.0;
                              break;
                            case 1:
                              _mainHeight += 100.0;
                              break;
                          }
                          steps++;
                        }));
              },
              height: _mainHeight,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: _receiptHeight,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: getReceiptInfo(),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ),
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    final boxWidth = constraints.constrainWidth();
                    final dashWidth = 10.0;
                    final dashHeight = 1.0;
                    final dashCount = (boxWidth / (2 * dashWidth)).floor();

                    return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Flex(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children: List.generate(dashCount, (_) {
                            return SizedBox(
                              width: dashWidth,
                              height: dashHeight,
                              child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white)),
                            );
                          }),
                        ));
                  }),
                  GestureDetector(
                    child: Container(
                      width: double.maxFinite,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
                        child: SvGraphics.icon('barcode', color: Colors.black),
                      ),
                    ),
                    onVerticalDragUpdate: (details) {
                      if (details.globalPosition.dy > _originHeight ||
                          (details.globalPosition.dy < (_originHeight - 80)))
                        return;

                      setState(() => _mainHeight = details.globalPosition.dy);
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RoundedButton(
                  title: 'back_to_menu',
                  color: appTheme.textTheme.bodyText1?.color,
                  onPressed: () => Navigator.pop(context, true),
                  bg: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      );

  void onGetPaymentByrequisitesStatusResult({
    String? error,
    String? result,
  }) {
    setState(() {
      tranUpdated = true;

      if (result != null) {
        transaction.paynetReceipt = jsonDecode(result)['paynetReceipt'];
      }
    });
  }

  @override
  void onGetPaymentReceipt({dynamic receipt, dynamic error}) {
    if (receipt != null && mounted)
      setState(() => this.receipt = receipt.receipt);
  }

  void onSaveCheck() {}

  void onShowMessage(String title, String text) => showDialog(
        context: context,
        builder: (context) => showMessage(context, title, text,
            onSuccess: () => Navigator.pop(context)),
      );

  void checkStoragePermission() async {
    if ((await Permission.storage.status) != PermissionStatus.granted) {
      if (!await Permission.storage.request().isGranted) return;
    }
    saveReceiptToPdf(receipt ?? transaction.paymentReceipt['receipt']);
  }

  Future<String> getDataToPrint() async {
    final List<String> printList = [];
    final Map<String, dynamic> details =
        jsonDecode(transaction.paynetReceipt)['details'];

    details.forEach((key, value) {
      final String k = value['label'].toString();
      final String v = value['value'].toString();

      if (key.trim() == 'voucher_kod' || key.trim() == 'barcode') {
        printList.add(jsonEncode({
          'type': 'qrcode',
          'info': v,
          'size': 22,
          'align': 'CENTER',
        }));
      } else if (key.trim().isEmpty && v.trim().isNotEmpty) {
        printList.add(jsonEncode({
          'type': 'data',
          'info': v,
          'size': 30,
          'align': 'CENTER',
        }));
      } else if (v.trim().isNotEmpty) {
        if (key != "agent_inn") {
          printList.add(jsonEncode({
            'type': 'data',
            'info': '$k: $v',
            'size': 28,
            'align': 'LEFT',
          }));
        } else {
          printList.add(jsonEncode({
            'type': 'data',
            'info': '$k: 205917201',
            'size': 28,
            'align': 'LEFT',
          }));
        }
      }
    });

    if (transaction.mobileQrDto != null) {
      final PaymentQr mobileQrDto = transaction.mobileQrDto;

      printList.add(jsonEncode({
        'type': 'data',
        'info': '  ',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("uzpaynet_comission")}: ${mobileQrDto.paynetComission.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '${locale.getText("with_nds")}: ${mobileQrDto.vat.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("total_to_pay")}: ${mobileQrDto.totalAmount.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '  ',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("payment_type")}: ${mobileQrDto.paymentType.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '${locale.getText("cash")}: ${mobileQrDto.cash.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '${locale.getText("plastik")}: ${mobileQrDto.card.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("remains")}: ${mobileQrDto.remains.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '  ',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("bank_card_number")} (UZPAYNET): ${mobileQrDto.terminalId.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info':
            '${locale.getText("fiscal_sign")}: ${mobileQrDto.fiscalSign.toString()}',
        'size': 28,
        'align': 'LEFT',
      }));

      printList.add(jsonEncode({
        'type': 'data',
        'info': '  ',
        'size': 28,
        'align': 'LEFT',
      }));

      final png = await QrPainter(
        data: mobileQrDto.qrCodeUrl ?? '',
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
        gapless: false,
      ).toImageData(300);

      final decoded = png?.buffer.asUint8List();

      if (decoded != null) {
        final h = convert.hex.encode(decoded);

        printList.add(jsonEncode({
          'type': 'qrcode',
          'info': h,
          'size': 22,
          'align': 'CENTER',
        }));
      }

      /*printList.add(jsonEncode({
        'type': 'qrcode_from_link',
        'info': mobileQrDto.qrCodeUrl,
        'size': 22,
        'align': 'CENTER',
      }));*/

      printList.add(jsonEncode({
        'type': 'data',
        'info': '  ',
        'size': 28,
        'align': 'LEFT',
      }));
    }

    printLog(printList.toString());

    return printList.toString();
  }

  void saveReceiptToPdf(String receipt) async {
    var htmlReceipt = utf8.decode(base64Decode(receipt)).replaceAll('�', '');
    final Map<String, dynamic> details =
        jsonDecode(transaction.paynetReceipt)['details'];

    details.forEach((key, value) {
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
        (await directoryPath) ?? '', '/${transaction.merchantName}');
    OpenFilex.open(pdf.path);
  }

  void onCopied(String? value) => _keyScaffold
    ..currentState?.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: appTheme.textTheme.bodyText2?.color,
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            sprintf(locale.getText('copied'), [value]),
            style: appTheme.textTheme.bodyText2?.copyWith(
                fontSize: 15, color: appTheme.scaffoldBackgroundColor),
          ),
        ),
      ),
    );
}
