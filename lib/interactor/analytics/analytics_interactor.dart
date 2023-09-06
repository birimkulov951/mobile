import 'package:amplitude_flutter/amplitude.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push/appmetrica_push.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/interactor/analytics/analytics.dart';
import 'package:mobile_ultra/interactor/analytics/events/auth.dart';
import 'package:mobile_ultra/interactor/analytics/events/payment.dart';
import 'package:mobile_ultra/interactor/analytics/events/registration.dart';
import 'package:mobile_ultra/interactor/analytics/events/transfers_in.dart';
import 'package:mobile_ultra/interactor/analytics/events/verification.dart';
import 'package:mobile_ultra/interactor/analytics/services/amplitude_analytics_service.dart';
import 'package:mobile_ultra/interactor/analytics/services/appmetrica_analytics_service.dart';
import 'package:mobile_ultra/interactor/analytics/services/firebase_analytics_service.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/abroad_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/auth_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/onboarding_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/one_time_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/payment_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/registration_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/transfer_by_phone_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/transfers_in_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/transfers_out_tracker.dart';
import 'package:mobile_ultra/interactor/analytics/trackers/verification_tracker.dart';
import 'package:mobile_ultra/utils/inject.dart';

/// Интерактор для работы с аналитикой
@injectable
class AnalyticsInteractor {
  static late final instance = inject<AnalyticsInteractor>();

  /// Трекер для отправки событий регистрации [RegistrationAnalyticsEvent]
  late final registrationTracker = RegistrationTracker(_analytics);

  /// Трекер для отправки событий авторизаци [AuthAnalyticsEvent]
  late final authTracker = AuthTracker(_analytics);

  /// Трекер для отправки событий Верификации [VerificationAnalyticsEvent]
  late final verificationTracker = VerificationTracker(_analytics);

  /// Трекер для отправки событий исходящих переводов [TransfersOutAnalyticsEvent]
  late final transfersOutTracker = TransfersOutTracker(_analytics);

  /// Трекер для отправки событий исходящих переводов [TransfersInAnalyticsEvent]
  late final transfersInTracker = TransfersInTracker(_analytics);

  /// Трекер для отправки событий оплаты [PaymentAnalyticsEvent]
  late final paymentTracker = PaymentTracker(_analytics);

  /// Трекер для отправки событий онбординга [OnboardingTracker]
  late final onboardingTracker = OnboardingTracker(_analytics);

  /// Трекер для отправки событий при переводе по номеру телефона [TransferByPhoneTracker]
  late final transferByPhone = TransferByPhoneTracker(_analytics);

  /// Трекер для отправки событий перевода за границу [AbroadTracker]
  late final abroadTracker = AbroadTracker(_analytics);

  late final oneTimeTracker = OneTimeTracker(_analytics);

  Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Amplitude.getInstance().init(dotenv.get("AMPLITUDE_KEY"));
    await AppMetrica.activate(AppMetricaConfig(dotenv.get("APP_METRICA_KEY")));
    await AppmetricaPush.instance.activate();
    await AppmetricaPush.instance.requestPermission(const PermissionOptions(
      alert: true,
      badge: true,
      sound: true,
    ));
  }

  void setUserId(String? userId) {
    _analytics.setUserId(userId);
  }

  final _analytics = Analytics([
    /// При добавлени нового сервиса аналитики на те же события,
    /// достаточно добавить его сюда
    FirebaseAnalyticsService(),
    AmplitudeAnalyticsService(inject()),
    AppMetricaAnalyticsService(),
  ]);
}
