import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/card/v3/all_cards/all_cards_screen.dart';
import 'package:mobile_ultra/screens/main/home/home_screen.dart';
import 'package:mobile_ultra/screens/main/home/home_screen_model.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/arguments.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/notification_route.dart';
import 'package:mobile_ultra/screens/main/home/notification/widgets/notification_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/home/widgets/enable_biometrics_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/accounts_page.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/add_new_account_page.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/pay_by_account_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_route.dart';
import 'package:mobile_ultra/screens/main/payments/v2/category_and_providers_widget.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/feedback_bottom_sheets.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

const _paynetCallCenterTelegram = 'https://t.me/PaynetCallCenter_bot';
const _requisiteMerchantId = 6710;

abstract class IHomeScreenWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin, IAttachedCardsWidgetModelMixin {
  abstract final EntityStateNotifier<MainData> allCardsData;
  abstract final EntityStateNotifier<List<PynetId>?> myAccountsList;
  abstract final ValueNotifier<bool> isBalanceHidden;
  abstract final EntityStateNotifier<MonthlyCashbackEntity> monthlyCashback;
  abstract final EntityStateNotifier<WeeklyCashbackEntity> weeklyCashback;
  abstract final EntityStateNotifier<List<NotificationEntity>?> news;

  Future<void> addNewAccount();

  Future<void> openChosenAccountDetailsScreen(PynetId account);

  void goToMyAccountsScreen();

  Future<void> openAllCardsScreen();

  void postFeedbackAsUndefined();

  void onNotificationsTap();

  void onSupportTap();

  void onQRPaymentTap();

  void onRequisitePaymentTap();

  void onFastPaymentTap();

  void flipBalanceVisibility();

  String get phoneNumber;

  Future<void> refreshHomeScreen();

  Future<void> openCardEditScreen(AttachedCard card);

  Future<void> openCardAddScreen();

  Future<void> onNotificationTap(NotificationEntity notification);

  void dismissNotification(NotificationEntity notification);
}

class HomeScreenWidgetModel extends WidgetModel<HomeScreen, HomeScreenModel>
    with
        SystemWidgetModelMixin<HomeScreen, HomeScreenModel>,
        AttachedCardsWidgetModelMixin<HomeScreen, HomeScreenModel>,
        AutomaticKeepAliveWidgetModelMixin<HomeScreen, HomeScreenModel>
    implements IHomeScreenWidgetModel {
  HomeScreenWidgetModel(super.model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _getFeedbackStatus();
    _shouldAskEnableBiometrics();
    refreshHomeScreen().then((_) => model.trackAll());
  }

  @override
  void dispose() {
    myAccountsList.dispose();
    isBalanceHidden.dispose();
    monthlyCashback.dispose();
    weeklyCashback.dispose();
    allCardsData.dispose();
    super.dispose();
  }

  @override
  late final EntityStateNotifier<MainData> allCardsData =
      EntityStateNotifier<MainData>();

  @override
  late final EntityStateNotifier<List<PynetId>?> myAccountsList =
      EntityStateNotifier<List<PynetId>>();

  @override
  late final ValueNotifier<bool> isBalanceHidden =
      ValueNotifier(model.isBalanceVisible);

  @override
  late final EntityStateNotifier<MonthlyCashbackEntity> monthlyCashback =
      EntityStateNotifier<MonthlyCashbackEntity>();

  @override
  late final EntityStateNotifier<WeeklyCashbackEntity> weeklyCashback =
      EntityStateNotifier<WeeklyCashbackEntity>();

  @override
  late final EntityStateNotifier<List<NotificationEntity>?> news =
      EntityStateNotifier<List<NotificationEntity>>();

  @override
  String get phoneNumber => formatPhoneNumber(model.phoneNumber);

  @override
  Future<void> refreshHomeScreen() async {
    await Future.wait([
      _fetchAllMyAccounts(),
      _fetchMonthlyCashback(),
      _fetchWeeklyCashback(),
      _fetchCardsAndBalances(),
      _fetchNews(),
    ]);
  }

  Future<void> _fetchAllMyAccounts() async {
    final previousData = myAccountsList.value?.data;
    myAccountsList.loading(previousData);

    final myAccountsData = await model.fetchMyAccounts();
    myAccountsList.content(myAccountsData ?? []);

    accountList = myAccountsData ?? [];
  }

  Future<void> _fetchMonthlyCashback() async {
    monthlyCashback.loading(monthlyCashback.value?.data);
    final cashback = await model.getMonthlyCashback();
    monthlyCashback.content(cashback);
  }

  Future<void> _fetchWeeklyCashback() async {
    weeklyCashback.loading(weeklyCashback.value?.data);
    final cashback = await model.getWeeklyCashback();
    weeklyCashback.content(cashback);
  }

  Future<void> _fetchCardsAndBalances() async {
    allCardsData.loading(allCardsData.value?.data);
    await getAttachedCards();
    await getActualBalance();
    allCardsData.content(MainData(
      cards: homeData?.cards ?? [],
      totalBalance: homeData?.totalBalance ?? 0,
    ));
  }

  Future<void> _fetchNews() async {
    news.loading(news.value?.data);
    final fetchedNews = await model.fetchNews();
    news.content(fetchedNews);
  }

  @override
  Future<void> onNotificationTap(NotificationEntity notification) async {
    await NotificationBottomSheet.show(
      context,
      data: notification,
    );
    dismissNotification(notification);
  }

  @override
  void dismissNotification(NotificationEntity notification) {
    model.saveNotificationAsRead(notification);
    final notifications = news.value!.data!;
    notifications.removeAt(0);
    news.content(notifications);
  }

  @override
  void flipBalanceVisibility() async {
    isBalanceHidden.value = await model.flipBalanceVisibility();
  }

  @override
  Future<void> addNewAccount() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryAndProvidersWidget(inject()),
      ),
    );

    if (result != null) {
      final isNewAccountCreated = await Navigator.push(
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

      if (isNewAccountCreated) {
        _fetchAllMyAccounts();
      }
    }
  }

  @override
  void goToMyAccountsScreen() async {
    final doesHomeScreenNeedsUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountsPage(model.merchantRepository),
      ),
    );

    if (doesHomeScreenNeedsUpdate) {
      _fetchAllMyAccounts();
    }
  }

  @override
  Future<void> openChosenAccountDetailsScreen(PynetId account) async {
    //TODO (Abdurahmon): shift database operations to data layer
    final merchant = account.merchantId == null
        ? null
        : model.merchantRepository.findMerchant(account.merchantId!);

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
      _fetchAllMyAccounts();
    }
  }

  Future<void> _getFeedbackStatus() async {
    final response = await model.getFeedbackStatus();
    if (response.askForFeedback) {
      final isFeedbackStatusUndefined =
          await FeedbackBottomSheets.show(context: context);
      if (isFeedbackStatusUndefined == null) {
        postFeedbackAsUndefined();
      }
    }
  }

  @override
  void postFeedbackAsUndefined() {
    model.postFeedbackAsUndefined();
  }

  void _shouldAskEnableBiometrics() async {
    if (await model.shouldAskEnableBiometrics()) {
      EnableBiometricsBottomSheet.show(
        context: context,
        enableBiometrics: model.enableBiometrics,
        setBiometricsEnablingAsked: model.setBiometricsEnablingAsked,
      );
    }
  }

  @override
  void onNotificationsTap() => Navigator.pushNamed(
        context,
        NotificationScreenRoute.Tag,
        arguments: const NotificationScreenArguments(),
      );

  @override
  void onSupportTap() => launchUrl(
        Uri.parse(_paynetCallCenterTelegram),
        mode: LaunchMode.externalApplication,
      );

  @override
  void onQRPaymentTap() async {
    if (!(await checkPermission(PermissionRequest.cameraQr()))) {
      return;
    }
    final result = await Navigator.pushNamed<dynamic>(
      context,
      TransferByQRScreen.Tag,
    );

    if (result != null) {
      widget.onQReadResult.call(result);
    }
  }

  @override
  void onFastPaymentTap() async {
    final openHistoryPage =
        await Navigator.of(context).pushNamed(FastPaymentScreenRoute.Tag);
    if (openHistoryPage == true) {
      widget.onGoHistory();
    }
  }

  @override
  void onRequisitePaymentTap() async {
    final merchant =
        model.merchantRepository.findMerchant(_requisiteMerchantId);

    if (merchant != null) {
      final paymentParams = PaymentParams(
        merchant: merchant,
        title: locale.getText('pay_by_requisites').replaceAll('\n', ' '),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => getUniquePaymentWidget(paymentParams),
        ),
      );
    }
  }

  @override
  Future<void> openAllCardsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllCardsScreen()),
    );

    if (result == true) {
      _fetchCardsAndBalances();
    }
  }

  @override
  Future<void> openCardEditScreen(AttachedCard card) async {
    final result = await super.onEditCard(card);

    if (result == true) {
      _fetchCardsAndBalances();
    }
  }

  @override
  Future<void> openCardAddScreen() async {
    final AttachedCard? result = await super.addNewCard();

    if (result != null) {
      await _fetchCardsAndBalances();
      Toast.show(
        context,
        title: locale.getText('card_added_successfully'),
        type: ToastType.success,
      );
    }
  }
}

HomeScreenWidgetModel homeScreenWidgetModelFactory(_) => HomeScreenWidgetModel(
      HomeScreenModel(
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
      ),
    );
