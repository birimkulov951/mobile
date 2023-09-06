import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/main/profile/settings/route/settings_route.dart';
import 'package:mobile_ultra/widgets/feedback_bottom_sheets/feedback_bottom_sheets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mobile_ultra/net/profile/modal/perosnal_data.dart';
import 'package:mobile_ultra/net/profile/profile_presenter.dart';
import 'package:mobile_ultra/screens/identification/intro/identification_intro.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/main/profile/personal_info_widget.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/profile/about.dart';
import 'package:mobile_ultra/screens/main/profile/reference_widget.dart';
import 'package:mobile_ultra/ui_models/wallet/wallet_status.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

const _paynetMail = 'support@paynet.uz';
const _paynetCallCenter = 'tel:+998712020707';
const _paynetCallCenterTelegram = 'https://t.me/PaynetCallCenter_bot';

class ProfileWidget extends StatefulWidget {
  static const String UpdateUI = "updateUI";
  static const String Logout = "logout";
  static const String Auth = "auth";
  static const String ReLogin = "reLogin";

  ProfileWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileWidgetState();
}

class ProfileWidgetState extends BaseInheritedTheme<ProfileWidget>
    with ProfileView {
  dynamic _result;
  bool _viewLoading = false;

  @override
  void initState() {
    super.initState();
    ProfilePresenter.profileButtonActive(this).getIdentification();
  }

  @override
  Widget get formWidget => WillPopScope(
        child: Stack(
          children: [
            layout,
            LoadingWidget(
              showLoading: _viewLoading,
              withProgress: true,
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(
            context,
            _result,
          );
          return false;
        },
      );

  Widget get layout => Scaffold(
        appBar: AppBar(
          title: TextLocale('profile'),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          actions: [
            IconButton(
                icon: SvgPicture.asset(Assets.profileSettings),
                onPressed: () async {
                  _result = await Navigator.pushNamed(
                      context, SettingsScreenRoute.Tag);

                  if (_result != null) {
                    switch (_result) {
                      case ProfileWidget.Auth:
                      case ProfileWidget.ReLogin:
                        Navigator.pop(
                          context,
                          _result,
                        );
                        break;
                      default:
                        setState(() {});
                        break;
                    }
                  }
                }),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title1(
                text: pref?.activeUser != false
                    ? pref?.fullName ?? ''
                    : '+${formatPayeeLogin(pref?.getViewLogin)}',
                // place here user name after pass identification
                size: 26,
                weight: FontWeight.w600,
                padding: const EdgeInsets.only(
                  left: Dimensions.unit2,
                  top: Dimensions.unit2,
                  right: Dimensions.unit2,
                ),
              ),
              Visibility(
                visible: pref?.activeUser ?? false,
                // set here user identifaction status
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.unit2,
                    top: Dimensions.unit,
                    right: Dimensions.unit2,
                  ),
                  child: Text(
                    '+${formatPayeeLogin(pref?.getViewLogin)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorNode.MainSecondary,
                    ),
                  ),
                ),
              ),
              ItemContainer(
                margin: const EdgeInsets.only(top: Dimensions.unit3),
                padding: const EdgeInsets.all(Dimensions.unit2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WalletStatus(isActive: pref?.activeUser ?? false),
                    Visibility(
                      visible: !(pref?.activeUser ?? true),
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.unit3,
                          bottom: Dimensions.unit3_5,
                        ),
                        child: TextLocale(
                          'identification_hint',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !(pref?.activeUser ?? true),
                      //hide if user is identified
                      child: RoundedButton(
                        title: 'confirm_my_person',
                        onPressed: _identificationIntro,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: pref?.activeUser ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Title1(
                      text: 'my_data',
                      size: 18,
                      weight: FontWeight.w700,
                      padding: const EdgeInsets.only(
                        left: Dimensions.unit2,
                        top: Dimensions.unit3,
                        bottom: Dimensions.unit1_5,
                      ),
                    ),
                    ItemContainer(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          CategoryRowItem(
                            leading: SvgPicture.asset(
                              'assets/graphics_redesign/personal.svg',
                            ),
                            leadingColor: Colors.white,
                            title: 'personal_data',
                            onTap: _viewPersonalInfo,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Title1(
                text: 'support',
                size: 18,
                weight: FontWeight.w700,
                padding: const EdgeInsets.only(
                  left: Dimensions.unit2,
                  top: Dimensions.unit3,
                  bottom: Dimensions.unit1_5,
                ),
              ),
              ItemContainer(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.telegram),
                      leadingColor: Colors.white,
                      title: 'assistant',
                      onTap: _launchTelegram,
                    ),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.call),
                      leadingColor: Colors.white,
                      title: 'call_center',
                      onTap: _callSupport,
                    ),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.mail),
                      leadingColor: Colors.white,
                      title: 'send_message_support',
                      onTap: _sendEmail,
                    ),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.rate),
                      leadingColor: ColorNode.ContainerColor,
                      title: locale.getText('rate_app'),
                      onTap: _openFeedback,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Title1(
                text: 'useful',
                size: 18,
                weight: FontWeight.w700,
                padding: const EdgeInsets.only(
                  left: Dimensions.unit2,
                  top: Dimensions.unit3,
                  bottom: Dimensions.unit1_5,
                ),
              ),
              ItemContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.about),
                      leadingColor: Colors.white,
                      title: 'about',
                      onTap: _viewAbout,
                    ),
                    CategoryRowItem(
                      leading: SvgPicture.asset(Assets.reference),
                      leadingColor: Colors.white,
                      title: 'reference',
                      onTap: _viewPreference,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.unit2,
                  Dimensions.unit3,
                  Dimensions.unit2,
                  MediaQuery.of(context).viewPadding.bottom,
                ),
                child: RoundedButton(
                  bg: Colors.transparent,
                  child: TextLocale(
                    'logout',
                    style: TextStyle(
                      color: ColorNode.MainSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: onClearAndLogout,
                ),
              ),
            ],
          ),
        ),
      );

  void _identificationIntro() {
    Navigator.of(context).pushNamed(IdentificationIntro.Tag);
  }

  void _viewPersonalInfo() {
    viewModalSheet(
      context: context,
      child: PersonalInfoWidget(),
      backgroundColor: ColorNode.Main,
    );
  }

  void _launchTelegram() => launchUrl(
        Uri.parse(_paynetCallCenterTelegram),
        mode: LaunchMode.externalApplication,
      );

  void _callSupport() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => showMessage(
          context,
          locale.getText('call_support'),
          locale.getText('call_support_confirm'),
          dismissTitle: locale.getText('cancel'),
          successTitle: locale.getText('call'),
          onDismiss: () => Navigator.pop(context),
          onSuccess: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 250), () async {
              final uri = Uri.parse(_paynetCallCenter);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => showMessage(
                    context,
                    locale.getText('error'),
                    locale.getText('unavailable'),
                    onSuccess: () => Navigator.pop(context),
                  ),
                );
              }
            });
          }),
    );
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _paynetMail,
    );

    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
          context,
          locale.getText('error'),
          locale.getText('unavailable'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
    }
  }

  void _viewAbout() {
    viewModalSheet(context: context, child: AboutWidget());
  }

  void _viewPreference() {
    viewModalSheet(context: context, child: ReferenceWidget());
  }

  Future<void> onClearAndLogout() async {
    var result = await viewAndroidModalSheetDialog(
          context: context,
          title: locale.getText('logout_title'),
          confirmBtnTitle: locale.getText('logout'),
          cancelBtnTitle: locale.getText('cancel'),
          confirmBtnTextStyle: uikit.Typographies.textMediumError,
          cancelBtnTextStyle: uikit.Typographies.textRegularSecondary,
        ) ??
        false;

    if (result) {
      setState(() => _viewLoading = true);

      pref?.setLaunchType(true);
      pref?.setAccessToken(null);
      pref?.setRefreshToken(null);
      pref?.setConfigUpdateTime(-1);
      pref?.setLogoUpdateTime(-1);
      pref?.setLogin(null);
      pref?.setViewLogin(null);
      pref?.setPin(null);
      pref?.setFullName(null);
      pref?.setActiveUser(null);
      pref?.setUserBirthDate(null);
      pref?.setUserDocument(null);
      pref?.madePay(false);
      pref?.setHiddenCardBalance(null);
      pref?.setLoginedAccount(null);
      pref?.saveSuggestions(null);
      pref?.setAccUpdTime(null);
      pref?.acceptPhoneScaleFactore(false);

      homeData = null;
      accountList.clear();
      reminderList.clear();
      favoriteList.clear();
      suggestionList.clear();
      sharingData = null;
      requestedFavorites = false;
      startFrom = NavigationWidget.HOME;

      try {
        await firebaseMessaging.unsubscribeFromTopic('global');
        await firebaseMessaging.unsubscribeFromTopic(locale.prefix);
      } on Object catch (e) {
        printLog(e);
      }

      await db?.clearAll();
      await DefaultCacheManager().emptyCache();

      Navigator.pop(
        context,
        ProfileWidget.Logout,
      );
    }
  }

  @override
  Future<void> onProfile({
    bool? isActive,
    String? error,
    errorBody,
    MyData? myData,
  }) async {
    if (isActive == true) {
      await pref?.setFullName(
        "${myData?.nameLatin ?? ''} ${myData?.surnameLatin ?? ''} ${myData?.patronYmLatin ?? ''}",
      );
      await pref?.setActiveUser(isActive);
      await pref?.setUserDocument(myData?.document);
      await pref?.setUserBirthDate(myData?.birthDate);
    } else {
      if (myData != null) {
        await pref?.setFullName(
          "${myData.nameLatin ?? ''} ${myData.surnameLatin ?? ''} ${myData.patronYmLatin ?? ''}",
        );
        await pref?.setUserDocument(myData.document);
        await pref?.setUserBirthDate(myData.birthDate);
      }
      if (isActive != null) {
        await pref?.setActiveUser(isActive);
      }
    }
    setState(() {});
  }

  void _openFeedback() => FeedbackBottomSheets.show(context: context);
}
