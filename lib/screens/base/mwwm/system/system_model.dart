import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/camera/scanned_card_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_filter.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';

import 'package:mobile_ultra/screens/base/mwwm/system/exceptions/card_scan_exception.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/exceptions/permanently_denied_exception.dart';

mixin SystemModelMixin on ElementaryModel {
  @protected
  late final SystemRepository systemRepository;

  Future<bool> checkPermission(PermissionRequest request) async {
    try {
      final permissions = await systemRepository.requestPermission(request);
      //ignore: only_throw_errors
      if (permissions.hasError) throw permissions.error!;
      switch (permissions.status) {
        case PermissionEntityStatus.granted:
          return true;
        case PermissionEntityStatus.denied:
          return false;
        case PermissionEntityStatus.permanentlyDenied:
          throw PermanentlyDeniedException(request);
      }
    } on Exception catch (error) {
      this.handleError(error);
      return false;
    }
  }

  Future<bool> openApplicationSettings() async {
    try {
      return systemRepository.openApplicationSettings();
    } on Exception catch (error) {
      this.handleError(error);
      return false;
    }
  }

  Future<ScannedCardEntity?> scanCard() async {
    try {
      final scannedCard = await systemRepository.scanCard();
      if (scannedCard == null) {
        throw CardScanException();
      }
      return scannedCard;
    } on Exception catch (error) {
      this.handleError(error);
    }
  }

  Future<List<PhoneContactEntity>?> findContacts({
    String searchText = '',
  }) async {
    try {
      return await systemRepository.getPhoneContacts(
        filter: PhoneContactFilter.UzCountryCode(searchText),
      );
    } on Object catch (error) {
      this.handleError(error);
    }
  }
}
