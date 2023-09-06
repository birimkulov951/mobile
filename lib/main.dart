import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_ultra/data/storages/database.dart';
import 'package:mobile_ultra/data/storages/preference.dart';
import 'package:mobile_ultra/di/di_container.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/push_notification/push_notifications_interactor.dart';
import 'package:mobile_ultra/net/card/model/bonus_per_month.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/net/payment/model/reminder.dart';
import 'package:mobile_ultra/responsive_main_wrapper.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_route.dart';
import 'package:mobile_ultra/screens/card/addition/sms_confirm.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/card_addition_screen_route.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/route/edit_card_screen_route.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/rejected_message/identification_rejected_page.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/sucsess_message/identification_sucsess_page.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/try_again_message/identification_try_again_page.dart';
import 'package:mobile_ultra/screens/identification/intro/identification_intro.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_two.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/mrz_scanner_widget.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/qr_code.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/selfie_photo.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/notification_route.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/main/payments/auto_payments/autopayment.dart';
import 'package:mobile_ultra/screens/main/payments/category/category.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_route.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/route/fast_payment_failed_route.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_screen/fast_payment_screen_route.dart';
import 'package:mobile_ultra/screens/main/payments/payment_result.dart';
import 'package:mobile_ultra/screens/main/payments/payment_verification_widget.dart';
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/screens/main/payments/receipt.dart';
import 'package:mobile_ultra/screens/main/payments/search.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/book_fund/book_fund_add_to_widget.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/gnk/gnk.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/gnk/gnk_autopayment.dart';
import 'package:mobile_ultra/screens/main/payments/unique_payment_forms/mib_bpi/mib_bpi_autopayment.dart';
import 'package:mobile_ultra/screens/main/profile/settings/route/settings_route.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/transfer_abroad_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/transfer_abroad_receiver_search_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/transfer_abroad_result_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/transfer_details_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_confirmation/transfer_confirmation_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/transfer_result.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/route/transfer_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/route/transfer_screen_route.dart'
    as v3;
import 'package:mobile_ultra/screens/onboarding/route/onboarding_screen_route.dart';
import 'package:mobile_ultra/screens/qa/qa_page.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_route.dart';
import 'package:mobile_ultra/screens/registration/select_language.dart';
import 'package:mobile_ultra/start_screen.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/mc.dart';
import 'package:mobile_ultra/utils/my_theme.dart';
import 'package:mobile_ultra/utils/system_ui_overlay.dart';

Preference? pref;
late LocaleHelper locale = LocaleHelper.instance;
MUDatabase? db;
MainData? homeData;
BonusPerMonth? bonusPerMonthData;
String? sharingData;
int startFrom = NavigationWidget.HOME;
late ThemeData appTheme = MyTheme.currentTheme;

bool requestedFavorites = false;

double screenHeight = 0;
double statusBarHeight = 0;

List<PynetId> accountList = [];
List<Reminder> reminderList = [];
List<FavoriteEntity> favoriteList = [];
List<String> suggestionList = [];

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Map<String, dynamic>? pushData;

MC channel = MC();

const AndroidNotificationChannel channels = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> onHandleBackgroundMessage(RemoteMessage message) async {
  pushData = message.data;
}

String getAccessToken() {
  return '${pref?.tokenType} ${pref?.accessToken}';
}

// todo rename this class to 'paynet_app.dart' and move classes to another folder later to avoid conflicts
Future launchApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  updateSystemUIOverlay();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channels);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await disposeDi();
  await initDi();
  await AnalyticsInteractor.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(onHandleBackgroundMessage);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  PushNotificationsInteractor.instance.configure(
    onLaunch: (Map<String, dynamic> data) async => pushData = data,
    onResume: (Map<String, dynamic> data) async => pushData = data,
    onBackgroundMessage: onHandleBackgroundMessage,
  );

  db = inject();
  pref = inject();

  AppMetrica.runZoneGuarded(() {
    runApp(
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const LocaleHelperDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            Locale(LocaleHelper.Russian),
            Locale(LocaleHelper.Uzbek),
            Locale(LocaleHelper.English),
          ],
          locale: Locale(LocaleHelper.Russian),
          builder: (final BuildContext context, final Widget? child) =>
              MainResponsiveWrapper(
            child: child ?? const SizedBox(),
          ),
          routes: {
            StartWidget.Tag: (BuildContext context) => StartWidget(),
            NavigationWidget.Tag: (BuildContext context) =>
                NavigationWidget(inject()),
            TransferByQRScreen.Tag: (BuildContext context) =>
                TransferByQRScreen(),
            CardSMSConfirmWidget.Tag: (BuildContext context) =>
                CardSMSConfirmWidget(),
            PaymentResultWidget.Tag: (BuildContext context) =>
                PaymentResultWidget(),
            ReceiptWidget.Tag: (BuildContext context) => ReceiptWidget(),
            CategoryWidget.Tag: (BuildContext context) => CategoryWidget(),
            ProvidersWidget.Tag: (BuildContext context) => ProvidersWidget(
                  merchantRepository: inject(),
                ),
            SearchProvidersWidget.Tag: (BuildContext context) =>
                SearchProvidersWidget(inject()),
            AutoPaymentWidget.Tag: (BuildContext context) =>
                AutoPaymentWidget(),
            TransferResultWidget.Tag: (BuildContext context) =>
                TransferResultWidget(),
            PaymentVerificationWidget.Tag: (BuildContext context) =>
                PaymentVerificationWidget(),
            SelectLanguageWidget.Tag: (BuildContext context) =>
                SelectLanguageWidget(),
            TransferConfirmationScreen.Tag: (BuildContext context) =>
                TransferConfirmationScreen(),
            GNKPaymentWidget.Tag: (BuildContext context) => GNKPaymentWidget(),
            GNKAutoPaymentWidget.Tag: (BuildContext context) =>
                GNKAutoPaymentWidget(),
            BookFundAddToWidget.Tag: (BuildContext context) =>
                BookFundAddToWidget(),
            MIBBPIAutoPaymentWidget.Tag: (BuildContext context) =>
                MIBBPIAutoPaymentWidget(),
            IdentificationIntro.Tag: (BuildContext context) =>
                IdentificationIntro(),
            IdentificationStepOne.Tag: (BuildContext context) =>
                IdentificationStepOne(),
            IdentificationStepTwo.Tag: (BuildContext context) =>
                IdentificationStepTwo(),
            IdentificationSuccessPage.Tag: (_) => IdentificationSuccessPage(),
            IdentificationRejectedPage.Tag: (_) => IdentificationRejectedPage(),
            IdentificationtryAgainpage.Tag: (_) => IdentificationtryAgainpage(),
            QRViewExample.Tag: (_) => QRViewExample(),
            SelfiePhotoPage.Tag: (_) => SelfiePhotoPage(),
            QAPage.Tag: (_) => QAPage(),
            MrzScanner.Tag: (_) => MrzScanner(),
          }..addEntries([
              NotificationScreenRoute.mapEntry,
              TransferAbroadReceiverSearchScreenRoute.mapEntry,
              TransferDetailsScreenRoute.mapEntry,
              TransferAbroadConfirmationScreenRoute.mapEntry,
              TransferAbroadResultScreenRoute.mapEntry,
              TransferBanksScreenRoute.mapEntry,
              SettingsScreenRoute.mapEntry,
              FastPaymentScreenRoute.mapEntry,
              FastPaymentFailedRoute.mapEntry,
              TransferTemplateRoute.mapEntry,
              v3.TransferScreenRoute.mapEntry,
              TransferConfirmationScreenRoute.mapEntry,
              PhoneNumberLoginScreenRoute.mapEntry,
              OtpConfirmationScreenRoute.mapEntry,
              AuthPinScreenRoute.mapEntry,
              OnBoardingScreenRoute.mapEntry,
              EditCardScreenRoute.mapEntry,
              CardAdditionScreenRoute.mapEntry,
            ]),
          home: StartWidget(),
        ),
      ),
    );
  });
}
