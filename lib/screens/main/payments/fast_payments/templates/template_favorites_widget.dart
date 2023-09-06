import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show db, favoriteList, locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/pay_by_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/template_item.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_route.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class TemplateFavoritesWidget extends StatefulWidget {
  const TemplateFavoritesWidget(
    this.merchantRepository, {
    GlobalKey? key,
  }) : super(
          key: key,
        );

  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => TemplateFavoritesWidgetState();
}

class TemplateFavoritesWidgetState extends State<TemplateFavoritesWidget> {
  bool _editableItems = false;

  @override
  void dispose() {
    db?.updateFavoritesOrders();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      favoriteList.isEmpty ? _noTemplates : _reorderableList;

  Widget get _noTemplates => Column(
        children: [
          ItemContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.unit2,
              vertical: Dimensions.unit1_5,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.unit3),
              bottomRight: Radius.circular(Dimensions.unit3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title1(
                  text: 'no_favorites',
                  size: 18,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: Dimensions.unit1_5),
                Title1(
                  text: 'favorites_hint',
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      );

  Widget get _reorderableList => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 80,
        ),
        child: ReorderableListView(
          onReorder: _reorderItems,
          buildDefaultDragHandles: _editableItems,
          children: List.generate(
            favoriteList.length,
            (index) => TemplateItem(
              key: favoriteList[index].billId != null
                  ? Key('${WidgetIds.templatesPageFavoriteTemplateList}_$index')
                  : Key('${WidgetIds.templatesPageTransferTemplateList}_$index'),
              item: favoriteList[index],
              isLast: (favoriteList.length - 1) == index,
              index: index,
              viewControls: _editableItems,
              onTap: _payByTemplate,
              onDeleteItem: _attemptDeleteItem,
              templateType: favoriteList[index].billId != null
                  ? TemplateType.Favorite
                  : TemplateType.Transfer,
            ),
          ),
        ),
      );

  Future<void> _payByTemplate(int itemIndex) async {
    final favorite = favoriteList[itemIndex];

    if (favorite.type == FPIType.TRANSFER) {
      await Navigator.pushNamed(
        context,
        TransferTemplateRoute.Tag,
        arguments: TransferTemplateRouteArguments(favorite),
      );

      setState(() {});

      return;
    }

    final merchant = widget.merchantRepository
        .findMerchant(favorite.merchantData?.merchantId);

    if (merchant == null) {
      await showDialog(
        context: context,
        builder: (context) => showMessage(
          context,
          locale.getText('attention'),
          locale.getText('service_not_available'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayByTemplatePage(
          paymentParams: PaymentParams(
            merchant: merchant,
            title: favoriteTemplateName(favorite),
            paymentType: PaymentType.PAY_BY_TEMPLATE,
            account: PynetId(
              account: favorite.merchantData?.account,
              payBill: favorite.merchantData?.params,
            ),
            favorite: favorite,
            templateType: TemplateType.Favorite,
          ),
        ),
      ),
    );

    updateFavorites();
  }

  void _reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final int pos = min(newIndex, favoriteList.length - 1);
    final reorderItem = favoriteList.removeAt(oldIndex);
    reorderItem.order = pos;

    setState(() {
      favoriteList.insert(pos, reorderItem);
      for (int i = pos; i <= favoriteList.length - 1; i++) {
        favoriteList[i].order = i;
      }
    });

    if (reorderItem.id != null) {
      FavoritePresenter.reorderItem(
        id: reorderItem.id!,
        newOrder: pos,
      );
    }
  }

  Future<void> _attemptDeleteItem(int itemIndex) async {
    final result = await viewModalSheetDialog(
          context: context,
          title: locale.getText('del_template_title'),
          message: locale.getText('del_template_message'),
          confirmBtnTitle: locale.getText('delete'),
          confirmBtnTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorNode.Red,
          ),
          cancelBtnTitle: locale.getText('cancel'),
        ) ??
        false;

    if (result) {
      //_onLoad();
      FavoritePresenter.toDelete(
        id: favoriteList[itemIndex].id,
        onDeleted: () => setState(() {
          favoriteList.removeAt(itemIndex);
        }),
        onFail: (error, errorBody) => _onFail(error),
      );
    }
  }

  void _onFail(String error) => showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
          context,
          locale.getText('error'),
          error,
          onSuccess: () => Navigator.pop(context),
        ),
      );

  void updateFavorites() => setState(() {});

  void makeEditItems() => setState(() => _editableItems = !_editableItems);
}
