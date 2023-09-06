import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payments_screen_wm.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/favorite_list.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/last_merchants.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/merchant_category_list.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/merchant_items.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/merchant_placeholder.dart';
import 'package:mobile_ultra/screens/main/payments/v2/widgets/popular_merchants.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/cell_phone_payment/cell_phone_payment.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;

const _appBarTitleScale = 1.6;

class PaymentsScreen extends ElementaryWidget<IPaymentsScreenWidgetModel> {
  const PaymentsScreen({
    super.key,
  }) : super(paymentsScreenWidgetModelFactory);

  @override
  Widget build(IPaymentsScreenWidgetModel wm) {
    return LocaleBuilder(
      builder: (_, locale) {
        return CustomScrollView(
          controller: wm.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              collapsedHeight: kToolbarHeight,
              expandedHeight: kToolbarHeight + 24,
              pinned: true,
              backgroundColor: ColorNode.Background,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                expandedTitleScale: _appBarTitleScale,
                centerTitle: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.getText('payments'),
                      style: uikit.Typographies.title5,
                    ),
                    ValueListenableBuilder<PaymentScreenContent?>(
                      valueListenable: wm.screenContentState,
                      builder: (context, state, child) {
                        return Visibility(
                          visible: state != null,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              key: const Key(WidgetIds.paymentsSetZeroStateButton),
                              behavior: HitTestBehavior.opaque,
                              onTap: wm.onClearTap,
                              child: Container(
                                width: 24 / _appBarTitleScale,
                                height: 24 / _appBarTitleScale,
                                alignment: Alignment.center,
                                child: uikit.ActionIcons.close,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: uikit.RoundedContainer(
                      child: uikit.SearchInputV2(
                        key: const Key(WidgetIds.paymentsSearchInput),
                        controller: wm.controller,
                        focusNode: wm.focusNode,
                        hintText: locale.getText('service_name'),
                        onClearTap: wm.onClearTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<PaymentScreenContent?>(
                valueListenable: wm.screenContentState,
                builder: (context, state, _) {
                  if (state is LoadingPaymentScreenContent) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: uikit.RoundedContainer(
                        child: Column(
                          children: const [
                            MerchantPlaceholder(),
                            MerchantPlaceholder(),
                            MerchantPlaceholder()
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is FocusedPaymentScreenContent) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          LastMerchants(
                            lastMerchantsState: wm.lastSelectedMerchantsState,
                            onMerchantTap: wm.onMerchantTap,
                          ),
                          PopularMerchants(
                            popularMerchantsState: wm.popularMerchantsState,
                            onMerchantTap: wm.onMerchantTap,
                          )
                        ],
                      ),
                    );
                  }
                  if (state is MerchantsFoundPaymentScreenContent) {
                    if (state.foundMerchants.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          locale.getText('nothing_found'),
                          style: uikit.Typographies.textRegularSecondary,
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: uikit.RoundedContainer(
                        child: MerchantItems(
                          merchants: state.foundMerchants,
                          onMerchantTap: wm.onMerchantTap,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      FavoriteList(
                        openFavorites: wm.openFavorites,
                        favoritesState: wm.favoritesState,
                        createFavorite: wm.createFavorite,
                        onFavoriteTap: wm.onFavoriteTap,
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CellPhonePayment(
                          key: Key(WidgetIds.paymentsByPhoneNumberInput),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: uikit.RoundedContainer(
                          title: uikit.HeadlineV2(
                            title: locale.getText('service_payment'),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: MerchantCategoryList(
                              paymentCategoriesState: wm.paymentCategoriesState,
                              scrollTo: wm.scrollTo,
                              onShowProviders: wm.onShowProviders,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 80 + wm.bottomPadding),
            )
          ],
        );
      },
    );
  }
}
