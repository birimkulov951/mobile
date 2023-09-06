import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/screens/base/mwwm/favorite/favorite_model.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/add_new_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/pay_by_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_route.dart';
import 'package:mobile_ultra/screens/main/payments/v2/category_and_providers_widget.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';

mixin IFavoriteWidgetModelMixin on IWidgetModel {
  abstract final EntityStateNotifier<List<FavoriteEntity>> favoritesState;

  void createFavorite();

  void onFavoriteTap(FavoriteEntity favorite);

  void openFavorites();
}

mixin FavoriteWidgetModelMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends FavoriteModelMixin> on WidgetModel<W, M>
    implements IFavoriteWidgetModelMixin {
  @override
  final EntityStateNotifier<List<FavoriteEntity>> favoritesState =
      EntityStateNotifier<List<FavoriteEntity>>(const EntityState.content([]));

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    fetchMyFavorites();
  }

  Future<void> fetchMyFavorites() async {
    favoritesState.loading(favoritesState.value?.data);
    final result = await model.fetchMyFavorites();
    favoritesState.content(result ?? []);
  }

  @override
  void createFavorite() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryAndProvidersWidget(inject()),
      ),
    );

    if (result != null) {
      final attached = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewTemplatePage(paymentParams: result),
            ),
          ) ??
          false;

      if (attached) {
        await fetchMyFavorites();
      }
    }
  }

  @override
  void onFavoriteTap(FavoriteEntity favorite) async {
    if (favorite.isTransfer) {
      await Navigator.pushNamed(
        context,
        TransferTemplateRoute.Tag,
        arguments: TransferTemplateRouteArguments(favorite),
      );
    } else {
      final merchant =
          await model.findMerchant(favorite.merchantData?.merchantId);

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
              account: PaynetId(
                account: favorite.merchantData?.account,
                payBill: favorite.merchantData?.params,
              ),
              favorite: favorite,
              templateType: TemplateType.Favorite,
            ),
          ),
        ),
      );
    }
    await fetchMyFavorites();
  }

  @override
  void openFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TemplatesPage(),
      ),
    );

    await fetchMyFavorites();
  }
}
