import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/interactor/analytics/data/payment_opened_data.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/screens/base/mwwm/favorite/favorite_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payments_screen.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payments_screen_model.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;
import 'package:rxdart/rxdart.dart';

abstract class IPaymentsScreenWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin, IFavoriteWidgetModelMixin {
  abstract final ScrollController scrollController;

  abstract final ValueNotifier<List<PaymentCategoryEntity>>
      paymentCategoriesState;

  abstract final ValueNotifier<List<MerchantEntity>> popularMerchantsState;

  abstract final ValueNotifier<List<MerchantEntity>> lastSelectedMerchantsState;

  abstract final ValueNotifier<PaymentScreenContent?> screenContentState;

  abstract final TextEditingController controller;

  abstract final FocusNode focusNode;

  void onClearTap();

  void onMerchantTap(MerchantEntity merchant);

  void setZeroState();

  void onShowProviders(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  );

  void scrollTo(int length);

  double get bottomPadding;
}

class PaymentsScreenWidgetModel
    extends WidgetModel<PaymentsScreen, PaymentsScreenModel>
    with
        SystemWidgetModelMixin<PaymentsScreen, PaymentsScreenModel>,
        FavoriteWidgetModelMixin<PaymentsScreen, PaymentsScreenModel>,
        AutomaticKeepAliveWidgetModelMixin<PaymentsScreen, PaymentsScreenModel>
    implements IPaymentsScreenWidgetModel {
  PaymentsScreenWidgetModel(super.model);

  @override
  final ValueNotifier<List<PaymentCategoryEntity>> paymentCategoriesState =
      ValueNotifier<List<PaymentCategoryEntity>>([]);

  @override
  final ValueNotifier<PaymentScreenContent?> screenContentState =
      ValueNotifier<PaymentScreenContent?>(null);

  @override
  final ScrollController scrollController = ScrollController();

  @override
  final TextEditingController controller = TextEditingController();

  @override
  final FocusNode focusNode = FocusNode();

  @override
  final ValueNotifier<List<MerchantEntity>> popularMerchantsState =
      ValueNotifier<List<MerchantEntity>>([]);

  @override
  late final ValueNotifier<List<MerchantEntity>> lastSelectedMerchantsState =
      ValueNotifier<List<MerchantEntity>>([]);

  late final BehaviorSubject<String> _searchSubject = BehaviorSubject();

  @override
  double get bottomPadding => MediaQuery.of(context).viewPadding.bottom;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _searchSubject
        .doOnData(_onTextInput)
        .debounceTime(Duration(milliseconds: 500))
        .listen(_searchMerchants);

    controller.addListener(_controllerListener);
    focusNode.addListener(_focusListener);
    scrollController.addListener(_scrollListener);
    _fetchLastSelectedMerchants();
    _fetchPopularMerchants();
    _fetchCategories();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _searchSubject.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void onClearTap() {
    setZeroState();
  }

  @override
  void setZeroState() {
    controller.clear();
    focusNode.unfocus();
    screenContentState.value = null;
  }

  @override
  void onMerchantTap(MerchantEntity merchant) async {
    _saveLastSelectedMerchant(merchant);

    final paymentParams = PaymentParams(
      title: await _getCategoryTitle(merchant),
      merchant: merchant,
      paymentType: PaymentType.MAKE_PAY,
      paymentOpenedSource: PaymentOpenedSource.categories,
      isFastPay: false,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => getUniquePaymentWidget(paymentParams),
      ),
    );
  }

  @override
  void scrollTo(int itemsCount) {
    scrollController.animateTo(
      scrollController.offset + (itemsCount * 56),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onShowProviders(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  ) async {
    //TODO(magomed): переделать когда  перепишем раздел оплаты
    if (categoryId.isNotEmpty && categoryId.first < 0) {
      await _launchPaymentPage(
        paymentParams: PaymentParams(
          title: title,
          merchant: await model.findMerchant(categoryId.first * -1),
          paymentOpenedSource: PaymentOpenedSource.categories,
        ),
      );
      return;
    }
    await uikit.BottomSheet.show(
      context: context,
      builder: (_) => ProvidersWidget(
        merchantRepository: inject(),
        title: title,
        categoryId: categoryId,
        excludeId: excludeId,
      ),
    );
  }

  Future<dynamic> _launchPaymentPage({
    required PaymentParams paymentParams,
  }) async {
    //TODO(magomed): переделать когда  перепишем раздел оплаты
    if (paymentParams.merchant == null) {
      await showDialog(
        context: context,
        builder: (context) => showMessage(
          context,
          locale.getText('attention'),
          locale.getText('service_not_available'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
      return null;
    }

    if (paymentParams.paymentType != PaymentType.NEW_TEMPLATE) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => getUniquePaymentWidget(paymentParams),
        ),
      );
    } else {
      return paymentParams.merchant;
    }
  }

  void _fetchCategories() async {
    final list = await model.fetchPaymentCategories();
    paymentCategoriesState.value = list ?? [];
  }

  void _controllerListener() async {
    final text = controller.text;
    final prevText = _searchSubject.valueOrNull ?? '';
    if (text == prevText) {
      return;
    }
    if (text.isEmpty) {
      screenContentState.value = FocusedPaymentScreenContent();
      return;
    }
    _searchSubject.add(text);
  }

  void _onTextInput(String text) {
    if (screenContentState.value is! LoadingPaymentScreenContent) {
      screenContentState.value = LoadingPaymentScreenContent();
    }
  }

  void _searchMerchants(String text) async {
    final foundMerchants = await model.findMerchants(text);
    if (screenContentState.value is LoadingPaymentScreenContent) {
      screenContentState.value =
          MerchantsFoundPaymentScreenContent(foundMerchants ?? []);
    }
  }

  void _focusListener() {
    final screenContent = screenContentState.value;
    if (focusNode.hasFocus && screenContent == null) {
      screenContentState.value = FocusedPaymentScreenContent();
    }
  }

  void _scrollListener() {
    focusNode.unfocus();
  }

  void _fetchPopularMerchants() async {
    final popularMerchants = await model.fetchPopularMerchants();
    popularMerchantsState.value = popularMerchants ?? [];
  }

  void _fetchLastSelectedMerchants() async {
    final lastSelectedMerchants = await model.fetchLastSelectedMerchants();
    lastSelectedMerchantsState.value = lastSelectedMerchants ?? [];
  }

  void _saveLastSelectedMerchant(MerchantEntity merchant) {
    model
        .saveLastSelectedMerchantId(merchant.id)
        .whenComplete(_fetchLastSelectedMerchants);
  }

  Future<String> _getCategoryTitle(MerchantEntity merchant) async {
    final categories = this.paymentCategoriesState.value;
    final category = categories.firstWhereOrNull(
      (element) => element.categoryIds.contains(merchant.categoryId),
    );
    if (category == null) {
      final merchantCategories = await model.fetchMerchantCategories();
      final merchantCategory = merchantCategories
          ?.firstWhereOrNull((element) => element.id == merchant.categoryId);
      switch (locale.prefix) {
        case LocaleHelper.Russian:
          return merchantCategory?.nameRu ?? '';
        default:
          return merchantCategory?.nameUz ?? '';
      }
    }
    return locale.getText(category.title);
  }
}

PaymentsScreenWidgetModel paymentsScreenWidgetModelFactory(
  BuildContext context,
) =>
    PaymentsScreenWidgetModel(
      PaymentsScreenModel(
        transferRepository: inject(),
        systemRepository: inject(),
        remoteConfigRepository: inject(),
        merchantRepository: inject(),
        favoriteRepository: inject(),
      ),
    );

abstract class PaymentScreenContent {}

class FocusedPaymentScreenContent extends PaymentScreenContent {}

class LoadingPaymentScreenContent extends PaymentScreenContent {}

class MerchantsFoundPaymentScreenContent extends PaymentScreenContent {
  MerchantsFoundPaymentScreenContent(this.foundMerchants);

  final List<MerchantEntity> foundMerchants;
}
