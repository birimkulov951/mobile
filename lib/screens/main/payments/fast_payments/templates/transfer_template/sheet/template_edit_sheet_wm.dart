import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/sheet/template_edit_sheet.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/sheet/template_edit_sheet_model.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template_wm.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';

enum TemplateEditSheetResultStatus {
  changed,
  removed,
}

class TemplateEditSheetResult {
  TemplateEditSheetResult({
    required this.status,
    this.changedName,
  });

  final TemplateEditSheetResultStatus status;
  final String? changedName;
}

abstract class ITemplateEditSheetWidgetModel extends IWidgetModel
    with IRemoteConfigWidgetModelMixin {
  abstract final TextEditingController nameController;

  abstract final FocusNode nameFocus;

  double get bottomPadding;

  abstract final StateNotifier<bool> isNameClearIconShownState;

  abstract final StateNotifier<ButtonStatus> isVisibleButtonState;

  void onNameClear();

  void onNameChanged(String value);

  void onTemplateSave();

  void onTemplateDelete();
}

class TemplateEditSheetWidgetModel
    extends WidgetModel<TemplateEditSheet, TemplateEditSheetModel>
    with RemoteConfigWidgetModelMixin<TemplateEditSheet, TemplateEditSheetModel>
    implements ITemplateEditSheetWidgetModel {
  TemplateEditSheetWidgetModel(super.model);

  late final FavoriteEntity template;

  final TextEditingController _nameController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();

  @override
  TextEditingController get nameController => _nameController;

  @override
  FocusNode get nameFocus => _nameFocus;

  @override
  double get bottomPadding {
    final screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return screenBottomPadding == 0 ? 16 : screenBottomPadding;
  }

  @override
  final StateNotifier<bool> isNameClearIconShownState =
      StateNotifier(initValue: false);

  @override
  final StateNotifier<ButtonStatus> isVisibleButtonState =
      StateNotifier(initValue: ButtonStatus.clickable);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    template = widget.template;
    _nameFocus.addListener(_amountFocusListener);
    _nameController.text = widget.title;
  }

  @override
  void dispose() {
    _nameFocus.removeListener(_amountFocusListener);
    _nameController.dispose();
    _nameFocus.dispose();
    isNameClearIconShownState.dispose();
    isVisibleButtonState.dispose();
    super.dispose();
  }

  @override
  void onNameClear() {
    FocusScope.of(context).unfocus();
    nameController.clear();
    isNameClearIconShownState.accept(nameController.text.isNotEmpty);
    isVisibleButtonState.accept(ButtonStatus.unclickable);
  }

  @override
  void onNameChanged(String value) {
    isNameClearIconShownState.accept(nameController.text.isNotEmpty);
    _updateButtonState();
  }

  void _updateButtonState() => nameController.text.isNotEmpty
      ? isVisibleButtonState.accept(ButtonStatus.clickable)
      : isVisibleButtonState.accept(ButtonStatus.unclickable);

  @override
  void onTemplateSave() {
    /// todo refactor according to Elementary
    /// Refactoring to Elementary may cause OTP bug.
    isVisibleButtonState.accept(ButtonStatus.loading);

    final newTemplateName = _nameController.text.trim();

    FavoritePresenter.edit(
      data: {
        'name': newTemplateName,
        'favoriteId': template.id,
      },
      onSuccess: ({data}) {
        isVisibleButtonState.accept(ButtonStatus.clickable);
        Navigator.pop(
          context,
          TemplateEditSheetResult(
            status: TemplateEditSheetResultStatus.changed,
            changedName: newTemplateName,
          ),
        );
      },
      onFail: (error, errorBody) => onError(error),
    );
  }

  void onError(String error, {dynamic errorBody}) {
    isVisibleButtonState.accept(ButtonStatus.clickable);
    showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
        context,
        locale.getText('error'),
        error,
        onSuccess: () => Navigator.pop(context),
      ),
    );
  }

  @override
  void onTemplateDelete() async {
    final isTemplateDeleted = await viewModalSheetDialog(
          context: context,
          title: locale.getText('del_template_title'),
          message: locale.getText('del_template_message'),
          confirmBtnTitle: locale.getText('delete'),
          confirmBtnTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorNode.Red,
          ),
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (isTemplateDeleted == true) {
      isVisibleButtonState.accept(ButtonStatus.loading);
      FavoritePresenter.toDelete(
        id: template.id,
        onDeleted: onTemplateDeleted,
        onFail: (error, errorBody) => onError(error),
      );
    }
  }

  void _amountFocusListener() => nameFocus.hasFocus
      ? isNameClearIconShownState.accept(nameController.text.isNotEmpty)
      : isNameClearIconShownState.accept(false);

  void onTemplateDeleted() {
    favoriteList.removeWhere((item) => item.id == template.id);
    isVisibleButtonState.accept(ButtonStatus.clickable);
    Navigator.pop(
      context,
      TemplateEditSheetResult(
        status: TemplateEditSheetResultStatus.removed,
      ),
    );
  }
}

TemplateEditSheetWidgetModel templateEditSheetWidgetModelFactory(_) =>
    TemplateEditSheetWidgetModel(TemplateEditSheetModel(inject()));
