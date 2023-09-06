import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/route/phone_number_login_screen_route.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/main.dart' show locale, pref;
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/select_language_button.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectLanguageWidget extends StatefulWidget {
  static const Tag = '/selectLanguage';

  @override
  State<StatefulWidget> createState() => SelectLanguageWidgetState();
}

class SelectLanguageWidgetState
    extends BaseInheritedTheme<SelectLanguageWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      _trackFirstLaunch();
    });
  }

  void _trackFirstLaunch() async {
    if ((await pref?.isAlreadyFirstOpen) ?? false) {
      return;
    }

    await pref?.setAlreadyFirstOpen(true);

    AnalyticsInteractor.instance.registrationTracker.trackLaunchFirstTime();
  }

  @override
  Widget get formWidget {
    final double twoWidth = (MediaQuery.of(context).size.width / 2) - 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ItemContainer(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title1(
                    text: 'wellcome',
                    padding: EdgeInsets.zero,
                    size: 28,
                    weight: FontWeight.w500,
                    color: ColorNode.Dark3),
                Title1(
                    text: 'Выберите язык приложения',
                    padding: const EdgeInsets.only(top: 28, bottom: 4),
                    size: 16,
                    weight: FontWeight.w400,
                    color: ColorNode.Dark3),
                Title1(
                  text: 'Ilova tilini tanlang',
                  padding: EdgeInsets.zero,
                  size: 14,
                  weight: FontWeight.w400,
                  color: ColorNode.GreyScale500,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectLanguageButton(
                          icon: Image.asset(
                            'assets/graphics_redesign/uz.png',
                            width: 36,
                            height: 28,
                          ),
                          width: twoWidth,
                          height: twoWidth * .7,
                          title: 'O’zbek',
                          isSelected: locale.prefix == LocaleHelper.Uzbek,
                          onClick: () => _changeLanguage(LocaleHelper.Uzbek),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SelectLanguageButton(
                          icon: Image.asset(
                            'assets/graphics_redesign/ru.png',
                            width: 36,
                            height: 28,
                          ),
                          width: twoWidth,
                          height: twoWidth * .7,
                          title: 'Русский',
                          isSelected: locale.prefix == LocaleHelper.Russian,
                          onClick: () => _changeLanguage(LocaleHelper.Russian),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          RoundedButton(
            title: 'continue',
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 28),
            onPressed: _checkUser,
          ),
          LocaleBuilder(
            builder: (_, lcoale) => RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: locale.getText('public_offer_1'),
                style: TextStyle(fontSize: 14, color: ColorNode.GreyScale500),
                children: [
                  TextSpan(
                    text: locale.getText('public_offer_2'),
                    style: TextStyle(color: ColorNode.Link),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () async {
                        if (await UrlLauncher.canLaunchUrl(
                            Const.PUBLIC_OFFER)) {
                          await UrlLauncher.launchUrl(
                            Const.PUBLIC_OFFER,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => showMessage(
                              context,
                              locale.getText('error'),
                              locale.getText('cant_open_link'),
                              onSuccess: () => Navigator.pop(context),
                            ),
                          );
                        }
                      },
                  ),
                  TextSpan(
                    text: locale.getText('public_offer_3'),
                    style: TextStyle(color: ColorNode.Link),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () async {
                        if (await UrlLauncher.canLaunchUrl(
                            Const.PUBLIC_OFFER2)) {
                          await UrlLauncher.launchUrl(
                            Const.PUBLIC_OFFER2,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => showMessage(
                              context,
                              locale.getText('error'),
                              locale.getText('cant_open_link'),
                              onSuccess: () => Navigator.pop(context),
                            ),
                          );
                        }
                      },
                  ),
                  TextSpan(
                    text: locale.getText('public_offer_4'),
                    style: TextStyle(color: ColorNode.GreyScale500),
                  ),
                  TextSpan(
                    text: locale.getText('public_offer_5'),
                    style: TextStyle(color: ColorNode.GreyScale500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 12),
        ],
      ),
    );
  }

  void _checkUser() => Navigator.pushNamed(
        context,
        PhoneNumberLoginScreenRoute.Tag,
        arguments: PhoneNumberLoginScreenArguments(),
      );

  void _changeLanguage(String newLang) =>
      locale.changeLanguage(newLang).then((value) => setState(() {
            locale = LocaleHelper.of(context);
          }));
}
