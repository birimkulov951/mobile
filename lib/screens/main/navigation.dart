import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/payment_opened_data.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_opened_data.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/model/payment/qr_pay_params.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_arguments.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_route.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/history/history_page.dart';
import 'package:mobile_ultra/screens/main/home/home_screen.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/arguments.dart';
import 'package:mobile_ultra/screens/main/home/notification/route/notification_route.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payments_screen.dart';
import 'package:mobile_ultra/screens/main/profile/profile.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/transfer_entrance_screen.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_route.dart';
import 'package:mobile_ultra/start_screen.dart';
import 'package:mobile_ultra/ui_models/navigation/navigation_category_item.dart';
import 'package:mobile_ultra/ui_models/various/progress_timer.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/qr_pay_decoder.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/bottom_bar_switcher.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget(this.merchantRepository, {super.key});

  static const Tag = '/navigationWidget';

  static const HOME = 0;
  static const TRANSFERS = 1;
  static const PAYMENTS = 2;
  static const STATISTICS = 3;

  static bool hasFreshNews = false;
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => NavigationWidgetState();
}

class NavigationWidgetState extends BaseInheritedTheme<NavigationWidget>
    with WidgetsBindingObserver {
  static const NEWS = 1;
  static const REMINDER = 2;
  static const RECEIPT = 3;
  static const TRANSFER = 4;

  bool _showBottomBar = true;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  int currentScreen = startFrom;

  ScaffoldFeatureController? snackBar;
  int doubleTapToExit = 0;

  Timer? timerToBlock;
  dynamic blockApp = false;
  bool alreadyBlocked = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initAndroidForegroundPushLocalNotification();
    initDeepLinks();
    WidgetsBinding.instance.addObserver(this);

    firebaseMessaging.subscribeToTopic('global').then(
          (value) => firebaseMessaging
              .subscribeToTopic(Platform.isIOS ? 'android' : 'ios')
              .then(
                (value) => firebaseMessaging.subscribeToTopic(locale.prefix),
              ),
        );

    onHandleIncomingMessage();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorNode.Background,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    timerToBlock?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void initAndroidForegroundPushLocalNotification() {
    final initialzationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher3');
    final initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification notification = message.notification!;
      final AndroidNotification android = message.notification!.android!;
      if (message.notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channels.id,
              channels.name,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    printLog('Navigation widget state: ${state.toString()}');

    if (state == AppLifecycleState.paused) {
      if (blockApp) {
        return;
      }

      timerToBlock = Timer.periodic(
        Duration(minutes: 2),
        (timer) {
          blockApp = true;
          timer.cancel();
        },
      );
    } else if (state == AppLifecycleState.resumed) {
      if (alreadyBlocked) {
        return;
      }

      if (blockApp) {
        alreadyBlocked = true;
        FocusScope.of(context).focusedChild?.unfocus();

        blockApp = await Navigator.pushNamed(
              context,
              AuthPinScreenRoute.Tag,
              arguments: AuthPinScreenArguments(),
            ) ??
            false;

        alreadyBlocked = blockApp;
      } else {
        timerToBlock?.cancel();
      }
      await onHandleIncomingMessage();
    }
  }

  void _switchBottomBar(bool show) {
    setState(() {
      _showBottomBar = show;
    });
  }

  Widget get _bottomNavigationBar {
    if (!_showBottomBar) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom * (-1),
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: Dimensions.unit2,
          right: Dimensions.unit2,
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Dimensions.unit3)),
          backgroundBlendMode: BlendMode.src,
          boxShadow: [
            BoxShadow(
              color: ColorNode.Shadow.withOpacity(.1),
              blurRadius: 40,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavigationCategoryItem(
              index: NavigationWidget.HOME,
              icon: 'assets/graphics_redesign/home.svg',
              title: locale.getText('home'),
              selected: currentScreen == NavigationWidget.HOME,
              onTap: _onTap,
            ),
            NavigationCategoryItem(
              index: NavigationWidget.TRANSFERS,
              icon: 'assets/graphics_redesign/transfer.svg',
              title: locale.getText('transfers'),
              selected: currentScreen == NavigationWidget.TRANSFERS,
              onTap: (index) {
                AnalyticsInteractor.instance.transfersOutTracker
                    .trackTransferOpened(source: TransferOpenedSource.navbar);
                _onTap(index);
              },
            ),
            NavigationCategoryItem(
              index: NavigationWidget.PAYMENTS,
              icon: 'assets/graphics_redesign/wallet.svg',
              title: locale.getText('payments'),
              selected: currentScreen == NavigationWidget.PAYMENTS,
              onTap: _onTap,
            ),
            NavigationCategoryItem(
              index: NavigationWidget.STATISTICS,
              icon: 'assets/graphics_redesign/clock.svg',
              title: locale.getText('history'),
              selected: currentScreen == NavigationWidget.STATISTICS,
              onTap: _onTap,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget get formWidget => WillPopScope(
        child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: [
              BottomBarSwitcher(
                showBottomBar: _showBottomBar,
                switchBottomBar: _switchBottomBar,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      HomeScreen(
                        onQReadResult: onQReadResult,
                        onGoHistory: () => _onTap(NavigationWidget.STATISTICS),
                        onProfile: onProfile,
                      ),
                      TransferEntranceScreen(
                        onQReadResult: onQReadResult,
                      ),
                      PaymentsScreen(),
                      const HistoryPage(),
                    ],
                  ),
                ),
              ),
              _bottomNavigationBar
            ],
          ),
        ),
        onWillPop: () async {
          if (doubleTapToExit == 0) {
            snackBar = scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                duration: Duration(seconds: 5),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ProgressTimer(() => snackBar?.close()),
                    SizedBox(width: 10),
                    Text(
                      locale.getText('double_tap_to_exit'),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            );

            snackBar?.closed.then((value) => doubleTapToExit = 0);
          }

          doubleTapToExit++;
          if (doubleTapToExit == 2) {
            SystemNavigator.pop();
          }
          return false;
        },
      );

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      printLog('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      printLog('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    onQReadResult(uri.toString());
  }

  void onQReadResult(String link) async {
    printLog(link);

    if (link.contains('app.paynet.uz')) {
      if (link.contains('?qrp2p=')) {
        sharingData = link;

        Future.delayed(const Duration(milliseconds: 500), () {
          AnalyticsInteractor.instance.transfersOutTracker
              .trackTransferOpened(source: TransferOpenedSource.qrScan);
          _onTap(NavigationWidget.TRANSFERS);
        });
      } else if (link.contains('/?m=')) {
        sharingData = null;

        final int ampersantIndex = link.indexOf('&');

        final merchantId = int.parse(
          link.substring(
            link.indexOf('/?m=') + 4,
            ampersantIndex != -1 ? ampersantIndex : link.length,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () async {
          launchPaymentPage(
            paymentParams: PaymentParams(
              merchant: widget.merchantRepository.findMerchant(merchantId),
              title: locale.getText('payments'),
              deeplink: ampersantIndex == -1
                  ? ''
                  : link.substring(ampersantIndex + 1, link.length),
              paymentOpenedSource: PaymentOpenedSource.qrScan,
            ),
          );
        });
      }
    } else {
      final QRPayParams qrPayParams = qrPayDecoder(link);

      if (qrPayParams.merchantId != -1) {
        launchPaymentPage(
          paymentParams: PaymentParams(
            merchant:
                widget.merchantRepository.findMerchant(qrPayParams.merchantId),
            title: locale.getText('payments'),
            deeplink: qrPayParams.queryParams,
            startFromInforRequest: true,
            paymentOpenedSource: PaymentOpenedSource.qrScan,
          ),
        );
      }
    }
  }

  /// Handle firebase incoming push notification.
  ///
  /// {
  ///    "data":{
  ///       "click_action":"FLUTTER_NOTIFICATION_CLICK",
  ///       "id": 1, 1 - news, 2 - reminder, 3 - payment receipt
  ///       "details":{
  ///          "title":"Title message",
  ///          "message":"Message body",
  ///          "receipt":"Payment details. null or empty if id is not equals 3"
  ///       }
  ///    }
  /// }
  Future onHandleIncomingMessage() async {
    if (pushData == null) {
      return;
    }
    printLog('FirebaseMessage.onLaunch/onResume: $pushData');

    try {
      Navigator.of(context).popUntil(ModalRoute.withName(NavigationWidget.Tag));

      int pushId = -1, newsId = -1;

      if (Platform.isAndroid) {
        pushId = int.parse(pushData?['data']['id']);
        if (pushData?['data'].containsKey('details') ?? false)
          newsId = jsonDecode(pushData?['data']['details'])['news_id'];
        //transferId = jsonDecode(pushData['details'])['transfer_id'];
      } else {
        pushId = int.parse(pushData?['id']);
        if (pushData?.containsKey('details') ?? false)
          newsId = jsonDecode(pushData?['details'])['news_id'];
        // transferId = jsonDecode(pushData['details'])['transfer_id'];
        // todo 'transferId' is not handled by server yet
      }

      switch (pushId) {
        case NEWS:
          setState(() => NavigationWidget.hasFreshNews = true);
          await Future.delayed(
            const Duration(milliseconds: 500),
            () {
              final arguments = NotificationScreenArguments(newsId: newsId);
              return Navigator.pushNamed(
                context,
                NotificationScreenRoute.Tag,
                arguments: arguments,
              );
            },
          ).then((_) => setState(() {}));
          break;
        case REMINDER:
          Future.delayed(
            const Duration(milliseconds: 500),
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TemplatesPage(page: 1)),
            ),
          );
          break;
        default:
          break;
      }
    } on Object catch (e) {
      printLog('push data processing raise except: $e');
    } finally {
      pushData = null;
    }
  }

  Future<void> onProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProfileWidget(),
      ),
    );

    if (result != null) {
      switch (result) {
        case ProfileWidget.ReLogin:
          await Navigator.pushReplacementNamed(
            context,
            AuthPinScreenRoute.Tag,
            arguments: AuthPinScreenArguments(),
          );
          break;
        case ProfileWidget.Auth:
          await Navigator.pushNamed(
            context,
            PhoneNumberLoginScreenRoute.Tag,
            arguments: PhoneNumberLoginScreenArguments(forgotPassword: true),
          );
          break;
        case ProfileWidget.Logout:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => StartWidget(),
            ),
            (Route<dynamic> route) => false,
          );
          break;
        default:
          setState(() {});
          break;
      }
    }
  }

  void _onTap(index) {
    _pageController.jumpToPage(index);
    setState(() => currentScreen = index);
  }
}
