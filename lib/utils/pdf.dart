import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/utils/u.dart';

Future<String?> saveToPDF(
  Map<String, dynamic> data, {
  String? merchantId,
}) async {
  try {
    final document = pdf.Document();
    final items = <pdf.Widget>[];
    final ttf =
        pdf.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular-400.ttf'));

    try {
      if (merchantId != null && merchantId != '-1') {
        final fileInfo = await DefaultCacheManager().getFileFromMemory(
            '${Http.URL}pms2/api/v2/merchant/logo/$merchantId');

        if (fileInfo != null) {
          // ignore: deprecated_member_use
          /// TODO Прежняя версия, протестить новую
          // items.add(pdf.Image(
          //     PdfImage.file(
          //       document.document,
          //       bytes: fileInfo.file.readAsBytesSync(),
          //     ),
          //     width: 70,
          //     height: 70));
          // items.add(pdf.SizedBox(height: 10));
          items.add(
            pdf.Image(
              pdf.MemoryImage(
                fileInfo.file.readAsBytesSync(),
              ),
              width: 70,
              height: 70,
            ),
          );
          items.add(pdf.SizedBox(height: 10));
        }
      } else {
        /// TODO Прежняя версия, протестить новую
        // ignore: deprecated_member_use
        // items.add(pdf.Image(
        //     PdfImage.file(document.document,
        //         bytes: (await rootBundle.load('assets/image/logo_1.png'))
        //             .buffer
        //             .asUint8List()),
        //     width: 200,
        //     height: 100));
        items.add(pdf.Image(
            pdf.MemoryImage(
              (await rootBundle.load('assets/image/logo_1.png'))
                  .buffer
                  .asUint8List(),
            ),
            width: 200,
            height: 100));
        items.add(pdf.SizedBox(height: 10));
      }
    } on Exception catch (e) {
      printLog('Decode logo raise except: $e');
    }
    data.forEach(
      (key, value) {
        if (key == 'qr') {
          items.add(pdf.SizedBox(height: 10));
          items.add(
            pdf.BarcodeWidget(
              data: value,
              barcode: pdf.Barcode.qrCode(),
              width: 150,
              height: 150,
            ),
          );
          items.add(pdf.SizedBox(height: 10));
        } else {
          items.add(
            pdf.Row(
              mainAxisAlignment: pdf.MainAxisAlignment.center,
              children: [
                pdf.Expanded(
                  child: pdf.Align(
                    alignment: pdf.Alignment.centerRight,
                    child: pdf.Text(
                      '$key',
                      textAlign: pdf.TextAlign.right,
                      style: pdf.TextStyle(
                        font: ttf,
                        fontSize: 20,
                        color: PdfColors.grey,
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                pdf.SizedBox(width: 10),
                pdf.Expanded(
                  child: pdf.Text(
                    "$value",
                    style: pdf.TextStyle(
                      font: ttf,
                      fontSize: 20,
                      color: PdfColors.black,
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          );
        }
      },
    );

    document.addPage(pdf.MultiPage(
        pageFormat: PdfPageFormat.standard,
        build: (context) => items,
        crossAxisAlignment: pdf.CrossAxisAlignment.center));

    final file = new File(
        '${await directoryPath}/${DateTime.now().millisecondsSinceEpoch}.pdf');

    final Uint8List? doc = await document.save();

    if (doc != null) {
      file.writeAsBytesSync(doc);
    }

    return file.path;
  } on Exception catch (e) {
    printLog(e);
    return null;
  }
}
