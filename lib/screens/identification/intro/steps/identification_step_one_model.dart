import 'dart:io';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_scan_data.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mrz_parser/mrz_parser.dart';

import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_two.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/mrz_scanner_widget.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/qr_code.dart';

class IdentificationStepOneModel extends ElementaryModel with SystemModelMixin {
  IdentificationStepOneModel(
    SystemRepository systemRepository,
  ) {
    this.systemRepository = systemRepository;
  }


  Future<void> onScanPassport(BuildContext context) async {
    if (!await checkPermission(PermissionRequest.cameraPassport())) {
      return;
    }

    if (Platform.isAndroid) {
      List<dynamic> result = await systemRepository.invokeMethodChannelNfc();

      if (result.length == 0) {
        printLog("MRZ :::::-----");
        printLog("MRZ: Пройдите nfc сканирование");
        return;
      }

      if (result.length == 2) {
        final mrz = [result[0].toString(), result[1].toString()];
        try {
          final mrzRes = MRZParser.parse(mrz);

          AnalyticsInteractor.instance.verificationTracker
              .trackScanPassed(VerificationScanDocuments.passport);

          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            IdentificationStepTwo.Tag,
            arguments: mrzRes,
          );
        } on MRZException {
          printLog("MRZ: Ошибка при считываниии документа.");
          printLog("MRZ :::::-----");
        }
        return;
      }
    } else if (Platform.isIOS) {
      final result = await Navigator.pushNamed(context, MrzScanner.Tag);

      if (result != null) {
        AnalyticsInteractor.instance.verificationTracker
            .trackScanPassed(VerificationScanDocuments.passport);

        Navigator.of(context).pop();
        Navigator.pushNamed(
          context,
          IdentificationStepTwo.Tag,
          arguments: result,
        );
      }
    }
  }

  Future<void> onScanIdCard(BuildContext context) async {
    if (!await checkPermission(PermissionRequest.cameraIdCard())) {
      return;
    }

    final result = await Navigator.pushNamed(context, QRViewExample.Tag);

    if (result != null) {
      AnalyticsInteractor.instance.verificationTracker
          .trackScanPassed(VerificationScanDocuments.id);

      Navigator.of(context).pop();
      Navigator.pushNamed(
        context,
        IdentificationStepTwo.Tag,
        arguments: result,
      );
    }
  }
}
