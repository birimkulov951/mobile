import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/main.dart' show accountList, db, locale, pref;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/net/payment/paynetid_presenter.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/base/base_accounts_state.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/add_new_account_page.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/pay_by_account_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/category_and_providers_widget.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/rows/account_row_item.dart';
import 'package:mobile_ultra/ui_models/rows/account_slide_menu_item.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _bottomHeight = 80.0;
const _refresherHeight = 150.0;
const _refresherPadding = 30.0;
const _refresherStrokeWidth = 2.0;
const _clampUpperLimit = 1.25;
const _clampHelper = 0.25;

/// Список закреплённых лицевых счетов (PaynetId) пользователя
class AccountsPage extends StatefulWidget {
  const AccountsPage(this.merchantRepository, {super.key});

  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => _AccountsPageState();
}

class _AccountsPageState extends BaseAccountsState<AccountsPage> {
  bool _editableItems = false;

  //update home screen my accounts if reorder, add or delete
  bool _myAccountsUpdated = false;

  Completer? updateCompleter;

  @override
  void initState() {
    super.initState();
    if (accountList.isEmpty)
      onReadAccounts();
    else if ((pref?.isMadePay ?? false)) onGetAccounts();
  }

  @override
  Widget get formWidget => Scaffold(
        appBar: AppBar(
          title: TextLocale('my_accounts'),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context, _myAccountsUpdated),
            icon: Icon(Platform.isIOS
                ? Icons.arrow_back_ios_new
                : Icons.arrow_back_rounded),
          ),
          actions: [
            Builder(
                builder: (_) => accountList.isNotEmpty
                    ? IconButton(
                        icon: SvgPicture.asset(
                            'assets/graphics_redesign/no_shape_settings.svg'),
                        onPressed: _editItems,
                      )
                    : SizedBox()),
          ],
        ),
        body: Stack(
          children: [
            accountList.isEmpty ? _tips : _accountList,
            LoadingWidget(showLoading: loading, withProgress: true),
          ],
        ),
      );

  Widget get _tips => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ItemContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.unit2,
                vertical: Dimensions.unit1_5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Title1(
                    text: 'attach_account_hint_1',
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                  const SizedBox(height: Dimensions.unit1_5),
                  Title1(
                    text: 'attach_account_hint_2',
                    size: Dimensions.unit2,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          RoundedButton(
            title: 'add_new_account',
            margin: EdgeInsets.only(
              left: Dimensions.unit2,
              right: Dimensions.unit2,
              bottom:
                  MediaQuery.of(context).viewPadding.bottom + Dimensions.unit2,
            ),
            onPressed: _addNewAccount,
          ),
        ],
      );

  Widget get _accountList => CustomRefreshIndicator(
        onRefresh: _onRefreshAccounts,
        builder: (context, child, controller) {
          return AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                final dy = controller.value.clamp(0.0, _clampUpperLimit) *
                    -(_refresherHeight - (_refresherHeight * _clampHelper));
                return Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(0.0, -dy),
                      child: child,
                    ),
                    Positioned(
                      top: -_refresherHeight,
                      left: 0,
                      right: 0,
                      height: _refresherHeight,
                      child: Container(
                        transform: Matrix4.translationValues(0.0, -dy, 0.0),
                        padding: const EdgeInsets.only(top: _refresherPadding),
                        constraints: const BoxConstraints.expand(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.isLoading)
                              SizedBox.square(
                                dimension: Dimensions.unit3,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorNode.Green),
                                  strokeWidth: _refresherStrokeWidth,
                                ),
                              )
                            else
                              const Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.green,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Stack(
          children: [
            ReorderableListView(
              onReorder: _onReorder,
              buildDefaultDragHandles: _editableItems,
              padding: const EdgeInsets.only(bottom: _bottomHeight),
              children: List.generate(
                accountList.length,
                (index) => AccountItem(
                  key: Key('account_$index'),
                  account: accountList[index],
                  viewControls: _editableItems,
                  onDeleteItem: onDeleteAccount,
                  onTap: _onTap,
                ),
              ),
            ),
            Positioned(
              left: Dimensions.unit2,
              right: Dimensions.unit2,
              bottom:
                  MediaQuery.of(context).viewPadding.bottom + Dimensions.unit2,
              child: RoundedButton(
                title: 'add_new_account',
                onPressed: _addNewAccount,
              ),
            )
          ],
        ),
      );

  void _editItems() => setState(() => _editableItems = !_editableItems);

  Future<void> _onRefreshAccounts() async {
    updateCompleter = Completer();
    onGetAccounts();
    await updateCompleter?.future;
  }

  @override
  void onGetPaynetIdList({String? error}) {
    updateCompleter?.complete();
    super.onGetPaynetIdList(error: error);
  }

  @override
  void onFail(String error, {errorBody}) {
    updateCompleter?.complete();
    super.onFail(error, errorBody: errorBody);
  }

  void _onReorder(int oldIndex, int newIndex) {
    _myAccountsUpdated = true;
    if (newIndex > oldIndex) newIndex -= 1;

    final int pos = min(newIndex, accountList.length - 1);
    final item = accountList.removeAt(oldIndex);

    setState(() {
      accountList.insert(pos, item);
      onReorder(item, pos + 1);
    });

    if (item.id != null) {
      PaynetIdPresenter.dragAndDrop(
        params: ['${item.id}', '${pos + 1}'],
        onError: onFail,
      );
    }
  }

  Future<void> _addNewAccount() async {
    final PaymentParams? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryAndProvidersWidget(widget.merchantRepository),
      ),
    );

    if (result != null) {
      final attached = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewAccountPage(
                paymentParams: result.copy(
                  paymentType: PaymentType.ADD_NEW_ACCOUNT,
                ),
              ),
            ),
          ) ??
          false;

      if (attached) {
        _onLoad(isLoading: true);
        onGetAccounts();
        _myAccountsUpdated = true;
      }
    }
  }

  Future<void> _onTap(PaynetId account) async {
    final merchant = account.merchantId == null
        ? null
        : widget.merchantRepository.findMerchant(account.merchantId!);

    if (merchant == null) {
      showDialog(
          context: context,
          builder: (context) => showMessage(
              context,
              locale.getText('attention'),
              locale.getText('service_not_available'),
              onSuccess: () => Navigator.pop(context)));
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayByAccountPage(
          paymentParams: PaymentParams(
            merchant: merchant,
            title: merchant.name,
            paymentType: PaymentType.MAKE_PAY,
            account: account,
          ),
        ),
      ),
    );

    if (result != null) {
      _onLoad(isLoading: true);
      onGetAccounts();
      _myAccountsUpdated = true;
    }
  }

  @override
  void onDeleteSuccess() {
    _myAccountsUpdated = true;
    DoubleNotification(value: 0).dispatch(context);
    super.onDeleteSuccess();
  }

  void _onLoad({bool isLoading = false}) => setState(() {
        loading = isLoading;
      });
}
