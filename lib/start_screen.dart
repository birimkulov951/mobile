import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/push_notification/push_notifications_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/main_presenter.dart';
import 'package:mobile_ultra/net/payment/merchant_presenter.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_arguments.dart';
import 'package:mobile_ultra/screens/auth/route/auth_pin_screen_route.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/registration/select_language.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/mc.dart';
import 'package:mobile_ultra/utils/my_theme.dart';

class StartWidget extends StatefulWidget {
  static const Tag = '/startScreen';

  @override
  StartWidgetState createState() => StartWidgetState();
}

class StartWidgetState extends BaseInheritedTheme<StartWidget> {
  AppUpdateStatus updateStatus = AppUpdateStatus.NO_UPDATE;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorNode.Background,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
    _trackLaunch();
  }

  void _trackLaunch() async {
    if ((await pref?.isAlreadyFirstOpen) ?? false) {
      AnalyticsInteractor.instance.authTracker.trackSessionOpen();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialization();
  }

  Future<void> _initialization() async {
    appTheme = MyTheme.currentTheme;

    final themeNode = pref?.themeNode;

    if (themeNode != null) {
      switchColors(Brightness.values[themeNode]);
    }

    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).viewPadding.top;

    MerchantPresenter(inject()).getAll();

    if (!((await db?.isHaveCardBeans) ?? false)) {
      MainPresenter.getCardBeans();
    }

    if (Platform.isAndroid) {
      if (pref?.isAnimateWidgets == null) {
        final android = await DeviceInfoPlugin().androidInfo;

        final sdkInt = android.version.sdkInt;

        if (sdkInt != null) {
          pref?.setAnimateWidgets(sdkInt >= 29);
        }
      }
    } else {
      pref?.setAnimateWidgets(true);
      await PushNotificationsInteractor.instance.requestPermission();
    }

    pref?.setLoginedAccount(null);
    suggestionList = pref?.suggestionList ?? suggestionList;

    channel.checkAppUpdate(onUpdateAvailableAndConfirm: (result) {
      if (result == AppUpdateStatus.NO_UPDATE) {
        Future.delayed(Duration(milliseconds: 350), () => _goToNext());
      } else if (Platform.isIOS && result == AppUpdateStatus.UPDATE_AVAILABLE) {
        _showIOSUpdateAlertDialog();
      } else if ((updateStatus == AppUpdateStatus.UPDATE_AVAILABLE ||
              updateStatus == AppUpdateStatus.UPDATING) &&
          result == AppUpdateStatus.UPDATE_CANCELED) {
        SystemNavigator.pop();
      }
    });
  }

  @override
  Widget get formWidget => Scaffold(
        backgroundColor: ColorNode.iphoneNativeBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'assets/image/logo_${appTheme.brightness.index}.png',
              width: 180,
              height: 180,
            ),
          ),
        ),
      );

  void _showIOSUpdateAlertDialog() async {
    final bool? update = await showDialog<bool?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => showMessage(
            context,
            locale.getText('attention'),
            locale.getText('available_new_app_version'),
            dismissTitle: locale.getText('cancel'),
            onDismiss: () => Navigator.pop(context, false),
            successTitle: locale.getText('update'),
            onSuccess: () => Navigator.pop(context, true),
          ),
        ) ??
        false;

    if (update ?? false) {
      channel.openAppStore();
    } else {
      SystemNavigator.pop();
    }
  }

  void _goToNext() {
    if (pref?.isFirstLaunch ?? false)
      Navigator.pushReplacementNamed(context, SelectLanguageWidget.Tag);
    else
      Navigator.pushReplacementNamed(
        context,
        AuthPinScreenRoute.Tag,
        arguments: AuthPinScreenArguments(),
      );
  }
}
