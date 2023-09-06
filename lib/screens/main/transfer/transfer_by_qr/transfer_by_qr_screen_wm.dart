import 'dart:io';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/model/payment/qr_pay_params.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen.dart';
import 'package:mobile_ultra/ui_models/modal_bottom_sheet/alert_bottom_sheet.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/qr_pay_decoder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen_model.dart';

const _smallScreenWidthLimit = 400;
const _overlaySizeForBigScreens = 300.0;
const _overlaySizeForSmallScreens = 200.0;
const _subDomain = 'main.example.com';

abstract class ITransferByQrScreenWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin {
  GlobalKey get qrKey;

  double get scanArea;

  double get bottomPadding;

  double get maxHeight;

  double get maxWidth;

  StateNotifier<bool> get isFlashOnState;

  void onQRViewCreated(QRViewController controller);

  void onToggleFlash();
}

class TransferByQrScreenWidgetModel
    extends WidgetModel<TransferByQRScreen, TransferTransferByQrScreenModel>
    with
        SystemWidgetModelMixin<TransferByQRScreen,
            TransferTransferByQrScreenModel>
    implements
        ITransferByQrScreenWidgetModel {
  TransferByQrScreenWidgetModel(TransferTransferByQrScreenModel model)
      : super(model);

  QRViewController? _qrViewController;

  GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  late double _scanArea;

  late double _bottomPadding;

  late double _maxHeight;

  late double _maxWidth;

  final StateNotifier<bool> _isFlashOn = StateNotifier<bool>(initValue: false);

  String? _scanResultCode;

  @override
  GlobalKey<State<StatefulWidget>> get qrKey => _qrKey;

  @override
  double get scanArea => _scanArea;

  @override
  double get bottomPadding => _bottomPadding;

  @override
  double get maxHeight => _maxHeight;

  @override
  double get maxWidth => _maxWidth;

  @override
  StateNotifier<bool> get isFlashOnState => _isFlashOn;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController?.pauseCamera();
    }
    _qrViewController?.resumeCamera();
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _scanArea = (MediaQuery.of(context).size.width < _smallScreenWidthLimit ||
            MediaQuery.of(context).size.height < _smallScreenWidthLimit)
        ? _overlaySizeForSmallScreens
        : _overlaySizeForBigScreens;
    _bottomPadding = MediaQuery.of(context).viewPadding.bottom + 16;
    _maxHeight = MediaQuery.of(context).size.height;
    _maxWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    _isFlashOn.dispose();
    super.dispose();
  }

  @override
  void onQRViewCreated(QRViewController controller) {
    _qrViewController ??= controller;
    _qrViewController?.scannedDataStream.listen((scanData) {
      _onQrScanListen(scanData);
    });

    _qrViewController?.pauseCamera();
    _qrViewController?.resumeCamera();
  }

  @override
  void onToggleFlash() async {
    await _qrViewController?.toggleFlash();
    _isFlashOn.accept(await _qrViewController?.getFlashStatus());
  }

  Future<void> _onQrScanListen(Barcode scanData) async {
    if (_scanResultCode == null) {
      final QRPayParams qrPayParams = qrPayDecoder(scanData.code!);
      _scanResultCode = scanData.code;
      if (scanData.code!.contains(_subDomain) || qrPayParams.merchantId != -1) {
        Navigator.pop(context, _scanResultCode);
      } else {
        _showModalBottomSheet();
      }
    }
  }

  void _showModalBottomSheet() {
    AlertBottomSheet.show(
            context: context,
            title: 'wrong_qr_scanned_error',
            bodyText: 'wrong_qr_scanned_error_desc',
            buttonText: 'good',
            maxPercentageHeight: 0.5)
        .then((_) => _scanResultCode = null);
  }
}

TransferByQrScreenWidgetModel transferByQrWidgetModelFactory(
        BuildContext context) =>
    TransferByQrScreenWidgetModel(TransferTransferByQrScreenModel(inject()));
