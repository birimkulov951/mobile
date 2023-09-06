import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/modal_bottom_sheet/custom_modal_bottom_sheet.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/utils/widget_ids.dart';

class OpenAppSettingsBottomSheet extends StatelessWidget {
  OpenAppSettingsBottomSheet({
    required this.request,
    this.onPressed,
  });

  final PermissionRequest request;
  final Function? onPressed;

  static void show(
    BuildContext context, {
    required PermissionRequest request,
    Function? onPressed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.unit3),
        ),
      ),
      builder: (BuildContext context) {
        return OpenAppSettingsBottomSheet(
          request: request,
          onPressed: onPressed,
        );
      },
    );
  }

  String _getTitle() {
    switch (request.reason) {
      case PermissionReason.qr:
        return locale.getText('open_app_settings_bottom_sheet_camera_qr_title');
      case PermissionReason.card:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_card_title');
      case PermissionReason.passport:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_passport_title');
      case PermissionReason.idCard:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_id_card_title');
      case PermissionReason.contacts:
        return locale.getText('open_app_settings_bottom_sheet_contacts_title');
      case PermissionReason.reports:
        return locale
            .getText('open_app_settings_bottom_sheet_storage_reports_title');
    }
  }

  String _getBodyText() {
    switch (request.reason) {
      case PermissionReason.qr:
        return locale.getText('open_app_settings_bottom_sheet_camera_qr_body');
      case PermissionReason.card:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_card_body');
      case PermissionReason.passport:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_passport_body');
      case PermissionReason.idCard:
        return locale
            .getText('open_app_settings_bottom_sheet_camera_id_card_body');
      case PermissionReason.contacts:
        return locale.getText('open_app_settings_bottom_sheet_contacts_body');
      case PermissionReason.reports:
        return locale
            .getText('open_app_settings_bottom_sheet_storage_reports_body');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalBottomSheet(
      maxPercentageHeight: 0.5,
      bottom: false,
      title: _getTitle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.unit2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: Dimensions.unit1_5,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                _getBodyText(),
                style: TextStyles.textRegular,
              ),
            ),
            Spacer(),
            RoundedButton(
              key: const Key(WidgetIds.openAppSettings),
              title: 'open_app_settings_bottom_sheet_button',
              onPressed: onPressed,
            ),
            SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom +
                    Dimensions.unit2)
          ],
        ),
      ),
    );
  }
}
