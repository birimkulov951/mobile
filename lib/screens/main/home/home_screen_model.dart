import 'package:elementary/elementary.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_ultra/data/api/dto/responses/feedback_status_response.dart';
import 'package:mobile_ultra/domain/feedback/feedback_entity.dart';
import 'package:mobile_ultra/domain/home/monthly_cashback_entity.dart';
import 'package:mobile_ultra/domain/home/weekly_cashback_entity.dart';
import 'package:mobile_ultra/domain/notification/notification_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';
import 'package:mobile_ultra/repositories/feedback_repository.dart';
import 'package:mobile_ultra/repositories/home_repository.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/repositories/notification_repository.dart';
import 'package:mobile_ultra/repositories/payment_repository.dart';
import 'package:mobile_ultra/repositories/settings_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';

class HomeScreenModel extends ElementaryModel
    with SystemModelMixin, AttachedCardsModelMixin {
  HomeScreenModel(
    SystemRepository systemRepository,
    CardsRepository cardsRepository,
    this._homeRepository,
    this._settingsRepository,
    this._feedbackRepository,
    this._paymentRepository,
    this._analyticsInteractor,
    this.merchantRepository,
    this._notificationRepository,
  ) {
    this.systemRepository = systemRepository;
    this.cardsRepository = cardsRepository;
  }

  final HomeRepository _homeRepository;
  final SettingsRepository _settingsRepository;
  final FeedbackRepository _feedbackRepository;
  final PaymentRepository _paymentRepository;
  final AnalyticsInteractor _analyticsInteractor;
  final MerchantRepository merchantRepository;
  final NotificationRepository _notificationRepository;

  Future<List<PynetId>?> fetchMyAccounts() async {
    try {
      return await _homeRepository.getMyAccounts();
    } on Object catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<FeedbackStatusResponse> getFeedbackStatus() async {
    try {
      return await _feedbackRepository.getFeedbackStatus();
    } on Object catch (e) {
      handleError(e);
      return const FeedbackStatusResponse(askForFeedback: false);
    }
  }

  void postFeedbackAsUndefined() async {
    try {
      await _feedbackRepository.postFeedback(
        const FeedbackEntity(feedbackStatus: FeedbackStatus.undefined),
      );
    } on Object catch (e) {
      handleError(e);
    }
  }

  Future<bool> shouldAskEnableBiometrics() async {
    if (!_homeRepository.isBiometricsEnablingAsked()) {
      return await LocalAuthentication().canCheckBiometrics;
    }
    return false;
  }

  Future<void> enableBiometrics() async {
    await _settingsRepository.setBiometricsEnabled(enableBiometrics: true);
  }

  Future<void> setBiometricsEnablingAsked() async {
    await _homeRepository.setBiometricsEnablingAsked();
  }

  bool get isBalanceVisible => _homeRepository.isBalanceVisible();

  String get phoneNumber => _homeRepository.phoneNumber;

  Future<bool> flipBalanceVisibility() async {
    await _homeRepository.setBalanceVisibility(isVisible: !isBalanceVisible);
    return isBalanceVisible;
  }

  Future<MonthlyCashbackEntity> getMonthlyCashback() async {
    return await _homeRepository.getMonthlyCashback();
  }

  Future<WeeklyCashbackEntity> getWeeklyCashback() async {
    return await _homeRepository.getWeeklyCashback();
  }

  //todo Abdurahmon - decide if this needed again
  Future<void> trackAll() async {
    if (_homeRepository.isAnalyticsSent()) {
      return;
    }
    try {
      final quantities = await Future.wait([
        _getCardsQuantity(),
        _getFavoritesQuantity(),
        _getMyAccountsQuantity(),
      ]);
      _analyticsInteractor.oneTimeTracker
          .trackAttachedCardsQuantity(quantities.first);
      _analyticsInteractor.oneTimeTracker.trackFavoritesQuantity(quantities[1]);
      _analyticsInteractor.oneTimeTracker
          .trackMyAccountsQuantity(quantities.last);
      await _homeRepository.setAnalyticsSent();
    } on Object catch (_) {}
  }

  Future<int> _getCardsQuantity() async {
    final cards = await cardsRepository.readStoredCards();
    final result = cards == null ? 0 : cards.length - 1;
    return result;
  }

  Future<int> _getFavoritesQuantity() async {
    final result = await _paymentRepository.getFavorites();
    return result.length;
  }

  Future<int> _getMyAccountsQuantity() async {
    final result = await _homeRepository.getMyAccounts();
    return result.length;
  }

  Future<List<NotificationEntity>> fetchNews() async {
    try {
      final readNotificationIds = _notificationRepository.readNotificationIds;
      final unreadNotifications = await _notificationRepository
          .getUnreadNotifications(readNotificationIds.toList());
      return unreadNotifications;
    } on Object catch (error) {
      handleError(error);
      return [];
    }
  }

  Future<void> saveNotificationAsRead(NotificationEntity notification) async {
    await _notificationRepository.saveNotificationAsRead(notification.id);
  }
}
