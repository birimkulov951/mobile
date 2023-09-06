import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen_wm.dart';

const _overlayBorderWidth = 5.0;
const _overlayBorderLength = 24.0;
const _overlayCutOutBottomOffset = 60.0;

class TransferByQRScreen
    extends ElementaryWidget<ITransferByQrScreenWidgetModel> {
  static const Tag = '/transferByQR';

  const TransferByQRScreen({
    Key? key,
  }) : super(transferByQrWidgetModelFactory, key: key);

  @override
  Widget build(ITransferByQrScreenWidgetModel wm) => Scaffold(
        appBar: PaynetAppBar(
          'qr_pay_helper',
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              height: wm.maxHeight,
              width: wm.maxWidth,
            ),
            QRView(
              key: wm.qrKey,
              onQRViewCreated: wm.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                cutOutSize: wm.scanArea,
                borderColor: ColorNode.Green,
                borderWidth: _overlayBorderWidth,
                borderLength: _overlayBorderLength,
                cutOutBottomOffset: _overlayCutOutBottomOffset,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: wm.bottomPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorNode.accent,
                ),
                child: TextLocale(
                  'hold_the_qr_code',
                  style: TextStyles.caption1.copyWith(
                    color: ColorNode.Background,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorNode.accent,
                ),
                child: StateNotifierBuilder(
                  listenableState: wm.isFlashOnState,
                  builder: (_, __) => IconButton(
                    icon: SvgPicture.asset(
                      wm.isFlashOnState.value == true
                          ? Assets.flashOn
                          : Assets.flashOff,
                      height: 16,
                      width: 16,
                    ),
                    onPressed: wm.onToggleFlash,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
