import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/utils/color_scheme.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'package:mobile_ultra/utils/u.dart';

class SelfiePhotoPage extends StatefulWidget {
  static const Tag = '/selfie-camera';

  const SelfiePhotoPage({Key? key}) : super(key: key);

  @override
  State<SelfiePhotoPage> createState() => _SelfiePhotoPageState();
}

class _SelfiePhotoPageState extends State<SelfiePhotoPage> {
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  bool _isRearCameraSelected = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _initCamera().then(
      (value) {
        cameraController = value;
        setState(() {});
      },
    );
  }

  Future<CameraController?> _initCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      printLog('${e.code} ${e.description}');
    }
    return await onNewCameraSelected(cameras[_isRearCameraSelected ? 1 : 0]);
  }

  Future<CameraController?> onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    setState(() {});
    try {
      await cameraController?.initialize();
      await cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } on CameraException catch (e) {
      printLog(e);
    }
    return cameraController;
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // ios only
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorNode.Dark1,
        body: Stack(
          children: [
            if (cameraController != null)
              Positioned.fill(
                child: (cameraController?.value.isInitialized ?? false)
                    ? Center(
                        child: CameraPreview(cameraController!),
                      )
                    : const SizedBox(),
              ),
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    AppBar(
                      elevation: 0,
                      backgroundColor: ColorNode.Dark1,
                      title: Text(
                        locale.getText('selfie'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: Container(
                            width: 300,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: Colors.transparent,
                              border: Border.all(
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 24,
                        bottom: 48,
                        left: 24,
                        right: 24,
                      ),
                      child: Text(
                        "Сделайте селфи снимок сопоставив лицо с маской",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 40.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: IconButton(
                            iconSize: 56,
                            splashRadius: 35,
                            onPressed: () async {
                              await takePicture().then(
                                (value) async {
                                  if (value != null) {
                                    Navigator.of(context).pop(value);
                                  }
                                },
                              );
                            },
                            icon: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: IconButton(
                            iconSize: 40,
                            splashRadius: 28,
                            onPressed: () async {
                              setState(() {
                                _isRearCameraSelected = !_isRearCameraSelected;

                                /// TODO зачем?
                                cameras[_isRearCameraSelected ? 1 : 0];
                              });
                              await _initCamera().then(
                                (value) {
                                  printLog('camera running====');
                                  cameraController = value;
                                  setState(() {});
                                },
                              );
                            },
                            icon: SvgPicture.asset(
                              "assets/graphics/camera_swap.svg",
                              height: 40.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> takePicture() async {
    if (!(cameraController?.value.isInitialized ?? false)) {
      printLog('Error: select a camera first');
      return null;
    }

    String base64string = '';
    if ((cameraController?.value.isTakingPicture ?? false)) {
      return null;
    }
    try {
      String filePath = (await cameraController?.takePicture())?.path ?? '';
      Io.File imagefile = Io.File(filePath); //convert Path to File
      final imagebytes = imagefile.readAsBytesSync(); //convert to bytes
      base64string = base64Encode(imagebytes); //convert bytes to base64 string
    } on CameraException catch (e) {
      printLog(e.description);
      return null;
    }
    return base64string;
  }
}
