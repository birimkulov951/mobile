import 'package:equatable/equatable.dart';

class PermissionEntity with EquatableMixin {
  PermissionEntity({
    required this.status,
    required this.request,
    this.error,
  });

  final PermissionEntityStatus status;
  final PermissionRequest request;
  final Object? error;

  bool get hasError => error != null;

  @override
  List<Object?> get props => [status, request, error];
}

class PermissionRequest with EquatableMixin {
  PermissionRequest.cameraQr()
      : this(
          type: PermissionEntityType.camera,
          reason: PermissionReason.qr,
        );

  PermissionRequest.cameraCard()
      : this(
          type: PermissionEntityType.camera,
          reason: PermissionReason.card,
        );

  PermissionRequest.cameraPassport()
      : this(
          type: PermissionEntityType.camera,
          reason: PermissionReason.passport,
        );

  PermissionRequest.cameraIdCard()
      : this(
          type: PermissionEntityType.camera,
          reason: PermissionReason.idCard,
        );

  PermissionRequest.contacts()
      : this(
          type: PermissionEntityType.contacts,
          reason: PermissionReason.contacts,
        );

  PermissionRequest.storage()
      : this(
          type: PermissionEntityType.storage,
          reason: PermissionReason.reports,
        );

  PermissionRequest({
    required this.type,
    required this.reason,
  });

  final PermissionEntityType type;
  final PermissionReason reason;

  @override
  List<Object> get props => [type, reason];
}

enum PermissionEntityStatus {
  denied,
  granted,
  permanentlyDenied,
}

/// Нужные типы разрешений добавлять здесь и реализовать в репозитории
enum PermissionEntityType {
  camera,
  contacts,
  storage,
}

/// Возможные причины запроса разрешения
enum PermissionReason {
  qr,
  card,
  contacts,
  passport,
  idCard,
  reports,
}
