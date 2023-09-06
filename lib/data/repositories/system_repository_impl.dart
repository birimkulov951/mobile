import 'package:card_scanner/card_scanner.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/domain/camera/scanned_card_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_filter.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:permission_handler/permission_handler.dart';

const String _methodChannel = "app.example.uz.mc";
const String _methodChannelNfcInvokeWith = "with_nfc";
const String _methodChannelNfcArgumentUseNfc = "use_nfc";

@Singleton(as: SystemRepository)
class SystemRepositoryImpl implements SystemRepository {
  const SystemRepositoryImpl(this._packageInfo);

  final PackageInfo _packageInfo;

  @override
  String get appVersion => _packageInfo.version;

  @override
  Future<PermissionEntity> getPermissionStatus(PermissionRequest request) {
    switch (request.type) {
      case PermissionEntityType.camera:
        return _handleFuture(Permission.camera.status, request);
      case PermissionEntityType.contacts:
        return _handleFuture(Permission.contacts.status, request);
      case PermissionEntityType.storage:
        return _handleFuture(Permission.storage.status, request);
    }
  }

  @override
  Future<PermissionEntity> requestPermission(PermissionRequest request) {
    switch (request.type) {
      case PermissionEntityType.camera:
        return _handleFuture(Permission.camera.request(), request);
      case PermissionEntityType.contacts:
        return _handleFuture(Permission.contacts.request(), request);
      case PermissionEntityType.storage:
        return _handleFuture(Permission.storage.request(), request);
    }
  }

  Future<PermissionEntity> _handleFuture(
    Future<PermissionStatus> future,
    PermissionRequest request,
  ) {
    return future
        .then((status) => _toEntity(request, status: status))
        .catchError((err) => _toEntity(request, error: err));
  }

  PermissionEntity _toEntity(PermissionRequest request,
      {PermissionStatus? status, Object? error}) {
    final permissionEntityStatus = status != null
        ? _toEntityStatus(status)
        : PermissionEntityStatus.denied;

    return PermissionEntity(
      request: request,
      status: permissionEntityStatus,
      error: error,
    );
  }

  PermissionEntityStatus _toEntityStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.provisional:
      case PermissionStatus.restricted:
        return PermissionEntityStatus.denied;
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return PermissionEntityStatus.granted;
      case PermissionStatus.permanentlyDenied:
        return PermissionEntityStatus.permanentlyDenied;

    }
  }

  @override
  Future<bool> openApplicationSettings() {
    return openAppSettings();
  }

  @override
  Future<ScannedCardEntity?> scanCard() async {
    final scanResult = await CardScanner.scanCard();
    if (scanResult == null) return null;
    return ScannedCardEntity(
        cardNumber: scanResult.cardNumber,
        cardHolder: scanResult.cardHolderName,
        expiryDate: scanResult.expiryDate);
  }

  @override
  Future<List> invokeMethodChannelNfc() async {
    return await const MethodChannel(_methodChannel).invokeMethod(
      _methodChannelNfcInvokeWith,
      {_methodChannelNfcArgumentUseNfc: false},
    );
  }

  @override
  Future<List<PhoneContactEntity>> getPhoneContacts(
      {required PhoneContactFilter filter}) async {
    final searchText = filter.searchText.toLowerCase();
    final countryCode = filter.phoneCountry.code;

    final contacts = await FastContacts.getAllContacts(
        fields: [ContactField.displayName, ContactField.phoneNumbers]);
    final result = contacts
        .where((contact) {
          return contact.phones.any((phone) {
            final number =
                tryToFullPhone(phone.number, countryCode) ?? phone.number;
            final displayName = contact.displayName.toLowerCase();
            return number.startsWith(countryCode) &&
                (number.contains(searchText) ||
                    displayName.contains(searchText));
          });
        })
        .expand(
          (contact) => contact.phones.map(
            (phone) => PhoneContactEntity(
                name: contact.displayName,
                phone:
                    tryToFullPhone(phone.number, countryCode) ?? phone.number),
          ),
        )
        .toList();

    return result;
  }
}
