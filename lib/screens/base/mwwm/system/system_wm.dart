import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/camera/scanned_card_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';

import 'package:mobile_ultra/screens/base/mwwm/system/exceptions/card_scan_exception.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/exceptions/permanently_denied_exception.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/widgets/open_app_settings_bottom_sheet.dart';

mixin ISystemWidgetModelMixin on IWidgetModel {
  Future<bool> checkPermission(PermissionRequest request);
}

mixin SystemWidgetModelMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends SystemModelMixin> on WidgetModel<W, M>
    implements ISystemWidgetModelMixin {
  @override
  Future<bool> checkPermission(PermissionRequest request) async {
    return model.checkPermission(request);
  }

  @override
  Future<ScannedCardEntity?> scanCard() async {
    if (await checkPermission(PermissionRequest.cameraCard())) {
      return model.scanCard();
    }
    return null;
  }

  Future<List<PhoneContactEntity>?> findContacts({
    String searchText = '',
  }) async {
    if (await checkPermission(PermissionRequest.contacts())) {
      return await model.findContacts(searchText: searchText);
    }
    return null;
  }

  @override
  void onErrorHandle(Object error) {
    if (error is PermanentlyDeniedException) {
      _showOpenAppSettingBottomSheet(error.request);
    }
    if (error is CardScanException) {}
    super.onErrorHandle(error);
  }

  _showOpenAppSettingBottomSheet(PermissionRequest request) {
    OpenAppSettingsBottomSheet.show(
      context,
      request: request,
      onPressed: model.openApplicationSettings,
    );
  }
}
