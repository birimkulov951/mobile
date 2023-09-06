import 'package:mobile_ultra/domain/permission/permission_entity.dart';

class PermanentlyDeniedException implements Exception {
  PermanentlyDeniedException(this.request);

  final PermissionRequest request;
}
