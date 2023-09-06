import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  static const Tag = '/qrcode';

  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MRZResult? mrz;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: ColorNode.Dark1,
        title: Text(
          locale.getText('id_scan2'),
        ),
        actions: [
          FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              return IconButton(
                icon: SvgPicture.asset(
                  "assets/graphics/flash_ic.svg",
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildQrView(context),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorNode.Dark3,
              ),
              child: Text(
                locale.getText('hold_the_qr_code'),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        /// TODO потенциальные ошибки
        /// если вернется строка меньше чисело взятия подстроки
        result = scanData;
        final code = result?.code?.replaceAll("\n", "");
        String? first = code?.substring(0, 30);
        String? second = code?.substring(30, 60);
        String? third = code?.substring(60, 90);
        mrz = MRZParser.parse([first, second, third]);
      });
      if (mrz != null) {
        controller.pauseCamera();
        Navigator.of(context).pop(mrz);
      }
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      printLog('no permission');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
