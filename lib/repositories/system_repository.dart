import 'package:mobile_ultra/domain/camera/scanned_card_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_filter.dart';

abstract class SystemRepository {
  String get appVersion;

  Future<PermissionEntity> requestPermission(PermissionRequest request);

  Future<PermissionEntity> getPermissionStatus(PermissionRequest request);

  Future<bool> openApplicationSettings();

  Future<ScannedCardEntity?> scanCard();

  Future<List<dynamic>> invokeMethodChannelNfc();

  Future<List<PhoneContactEntity>> getPhoneContacts({
    required PhoneContactFilter filter,
  });
}
