import 'package:flutter/widgets.dart';

import 'package:mobile_ultra/main.dart' show accountList, db, locale, pref;
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/net/payment/paynetid_presenter.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class BaseAccountsState<T extends StatefulWidget>
    extends BaseInheritedTheme<T> {
  bool loading = false;
  bool showTips = false;
  PaynetId? forDelete;

  @override
  Widget get formWidget => SizedBox();

  void onReadAccounts() {
    loading = true;
    db?.getMyAccounts().then((accounts) {
      if (accounts.isNotEmpty) {
        setState(() => accountList.addAll(accounts));
      }
      onGetAccounts();
    });
  }

  void onGetAccounts() => PaynetIdPresenter.getList(
        onGetList: onGetPaynetIdList,
        onError: onFail,
      );

  Future<void> onDeleteAccount(PaynetId paynetId) async {
    var result = await viewModalSheetDialog(
          context: context,
          title: locale.getText('confirm_delete_account'),
          confirmBtnTitle: locale.getText('delete'),
          confirmBtnTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorNode.Red,
          ),
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (result) {
      forDelete = paynetId;

      PaynetIdPresenter.delete(
        params: ['${forDelete?.merchantId}', '${forDelete?.account}'],
        onDeleteSuccess: onDeleteSuccess,
        onError: onFail,
      );
    }
  }

  void onReorder(PaynetId item, int newPos) => PaynetIdPresenter.dragAndDrop(
        params: ['${item.id}', '$newPos'],
        onError: onFail,
      );

  void onFail(String error, {errorBody}) => forDelete = null;

  void onGetPaynetIdList({String? error}) {
    if (mounted) {
      setState(() {
        loading = false;
        showTips = accountList.isEmpty;

        if (!showTips) {
          pref?.madePay(false);
          pref?.setAccUpdTime(DateTime.now().millisecondsSinceEpoch);
        }
      });
    }
  }

  void onDeleteSuccess() => setState(() {
        accountList.removeWhere((paynetId) =>
            paynetId.merchantId == forDelete?.merchantId &&
            paynetId.account == forDelete?.account);

        if (forDelete?.merchantId != null && forDelete?.account != null) {
          db?.deleteAccount(
            forDelete!.merchantId!,
            forDelete!.account!,
          );
        }

        forDelete = null;
      });
}
