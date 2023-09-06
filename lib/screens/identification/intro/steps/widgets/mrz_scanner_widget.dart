import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:permission_handler/permission_handler.dart';

class MrzScanner extends StatefulWidget {
  static const Tag = '/mrzScanner';

  const MrzScanner({Key? key}) : super(key: key);

  @override
  _MrzScannerState createState() => _MrzScannerState();
}

class _MrzScannerState extends State<MrzScanner> {
  bool isParsed = false;
  bool isFlashOn = false;
  bool isMessageVisible = false;

  MRZController? controller;

  @override
  void dispose() {
    controller?.stopPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      isMessageVisible = true;
    } else {
      isMessageVisible = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorNode.Dark1,
        title: Text(
          locale.getText('passport_scan2'),
        ),
        actions: [
          IconButton(
              onPressed: flashSwitch,
              icon: SvgPicture.asset('assets/graphics/flash_ic.svg')),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<PermissionStatus>(
              future: Permission.camera.request(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data == PermissionStatus.granted) {
                  return MRZScanner(
                    withOverlay: true,
                    onControllerCreated: (controller) =>
                        onControllerCreated(controller),
                  );
                }
                if (snapshot.data == PermissionStatus.permanentlyDenied) {
                  Navigator.pop(context);
                  openAppSettings();
                }

                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                );
              }),
          if (isMessageVisible)
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
                  locale.getText('hold_the_passport'),
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

  void onControllerCreated(MRZController controller) {
    this.controller = controller;
    controller.onParsed = (result) async {
      if (isParsed) {
        return;
      }
      isParsed = true;

      Navigator.pop(context, result);
    };
    controller.onError = (error) => printLog(error);

    controller.startPreview();
  }

  void flashSwitch() {
    if (isFlashOn) {
      isFlashOn = false;
      controller?.flashlightOff();
    } else {
      isFlashOn = true;
      controller?.flashlightOn();
    }
  }
}
