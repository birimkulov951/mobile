import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/payment/merchant_presenter.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/profile/profile.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings_screen_wm.dart';
import 'package:mobile_ultra/ui_models/buttons/select_language_button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/rows/switch_row_item.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    required this.wm,
    Key? key,
  }) : super();

  final ISettingsScreenWidgetModel wm;

  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends BaseInheritedTheme<SettingsWidget>
    with MerchantView {
  bool _loading = false;
  String? _exit;
  String _loadingMsg = '';

  @override
  Widget get formWidget {
    final double twoWidth = (MediaQuery.of(context).size.width / 2) - 20;

    return WillPopScope(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: TextLocale('settings'),
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Title1(
                    text: 'app_language',
                    padding:
                        const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                  ItemContainer(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                            onClick: () => onLangChanged(LocaleHelper.Uzbek),
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
                            onClick: () => onLangChanged(LocaleHelper.Russian),
                          ),
                        )
                      ],
                    ),
                  ),
                  Title1(
                    text: 'security',
                    padding:
                        const EdgeInsets.only(left: 16, top: 24, bottom: 12),
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                  ItemContainer(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryRowItem(
                          leading: SvgPicture.asset(Assets.stars),
                          title: 'change_pin',
                          onTap: widget.wm.changePin,
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.wm.isBiometricsEnabled,
                          builder: (_, bool isBiometricsEnabled, __) =>
                              SwitchRowItem(
                            isBiometricsEnabled: isBiometricsEnabled,
                            onTap: widget.wm.changeBiometricUseStatus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Title1(
                    text: 'additionally',
                    padding:
                        const EdgeInsets.only(left: 16, top: 24, bottom: 12),
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                  ItemContainer(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleShape(
                            size: 40,
                            child: SvgPicture.asset(
                              'assets/graphics_redesign/refresh.svg',
                              color: Colors.white,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.getText('update_services'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: ColorNode.Dark3,
                                ),
                              ),
                              Text(
                                DateFormat('dd.MM.yyyy HH:mm:ss').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    pref!.configUpdTime,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorNode.MainSecondary,
                                ),
                              )
                            ],
                          ),
                          onTap: _onUpdateServices,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          LoadingWidget(
            showLoading: _loading,
            withProgress: _loading,
            message: _loadingMsg,
          ),
        ],
      ),
      onWillPop: () async {
        Navigator.pop(context, _exit);
        return false;
      },
    );
  }

  @override
  void onGetAllData({String? error}) {
    setState(() {
      _loading = false;
      if (error != null) {
        showDialog(
          context: context,
          builder: (context) => showMessage(
            context,
            locale.getText('error'),
            error,
            onSuccess: () => Navigator.pop(context),
          ),
        );
      }
    });
  }

  @override
  void onShowLoading() => setState(() {
        _loadingMsg = locale.getText('updating_services');
        _loading = true;
      });

  void onLangChanged(String newLang) =>
      locale.changeLanguage(newLang).then((value) {
        setState(() {
          locale = value;
          _exit = ProfileWidget.UpdateUI;

          favoriteList.where(
            (fpi) =>
                fpi.type != FPIType.MERCHANT && fpi.type != FPIType.TRANSFER,
          );
        });

        firebaseMessaging
            .unsubscribeFromTopic(locale.prefix)
            .then((value) => firebaseMessaging.subscribeToTopic(newLang));
      });

  Future<void> _onUpdateServices() async {
    await DefaultCacheManager().emptyCache();
    await db?.clearAllDataMerchants();
    await widget.wm.clearAllPaymentData();
    MerchantPresenter(inject(), view: this).getData();
  }
}
