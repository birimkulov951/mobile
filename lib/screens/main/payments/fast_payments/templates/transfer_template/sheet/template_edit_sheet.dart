import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/sheet/template_edit_sheet_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template_wm.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class TemplateEditSheet
    extends ElementaryWidget<ITemplateEditSheetWidgetModel> {
  TemplateEditSheet({
    required this.template,
    required this.title,
    Key? key,
  }) : super(templateEditSheetWidgetModelFactory, key: key);

  final FavoriteEntity template;
  final String title;

  @override
  Widget build(ITemplateEditSheetWidgetModel wm) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextLocale(
                'template_settings',
                style: TextStyles.title4,
              ),
              SizedBox(height: 24),
              TextField(
                key: const Key(
                    WidgetIds.transferTemplateNameInput),
                focusNode: wm.nameFocus,
                controller: wm.nameController,
                style: TextStyles.textInput,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: locale.getText('template_name'),
                  floatingLabelStyle: TextStyles.caption1MainSecondary,
                  suffixIcon: StateNotifierBuilder<bool>(
                    listenableState: wm.isNameClearIconShownState,
                    builder: (context, state) => IconButton(
                      icon: state != null && state
                          ? SvgPicture.asset(Assets.clear)
                          : SizedBox.shrink(),
                      onPressed: wm.onNameClear,
                    ),
                  ),
                ),
                onChanged: wm.onNameChanged,
              ),
              Spacer(),
              SizedBox(height: 24),
              StateNotifierBuilder<ButtonStatus>(
                listenableState: wm.isVisibleButtonState,
                builder: (context, ButtonStatus? state) {
                  return RoundedButton(
                    key: const Key(
                        WidgetIds.transferTemplateSaveChangesButton),
                    title: 'save',
                    disabledBgColor: ColorNode.GreenDisabled,
                    loading: state == ButtonStatus.loading,
                    onPressed: state == ButtonStatus.clickable
                        ? wm.onTemplateSave
                        : null,
                  );
                },
              ),
              SizedBox(height: 16),
              RoundedButton(
                key: const Key(
                    WidgetIds.transferTemplateDeleteTemplate),
                bg: Colors.transparent,
                onPressed: wm.onTemplateDelete,
                child: TextLocale(
                  'delete_template',
                  style: TextStyles.captionButtonSecondary,
                ),
              ),
              SizedBox(height: wm.bottomPadding),
            ],
          ),
        ),
      );
}
