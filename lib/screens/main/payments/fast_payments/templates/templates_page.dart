import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart' show favoriteList, locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/add_new_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/template_favorites_widget.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/template_reminder_payments_widget.dart';
import 'package:mobile_ultra/screens/main/payments/v2/category_and_providers_widget.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

enum TemplateType {
  None,
  Favorite,
  Reminder,
  Transfer,
}

class TemplatesPage extends StatefulWidget {
  final int page;

  const TemplatesPage({
    this.page = 0,
  });

  @override
  State<StatefulWidget> createState() => TemplatesPageState();
}

class TemplatesPageState extends BaseInheritedTheme<TemplatesPage>
    with TickerProviderStateMixin {
  late final TabController _tabCtrl = TabController(
    initialIndex: widget.page,
    length: 2,
    vsync: this,
  );

  GlobalKey<TemplateFavoritesWidgetState> _favoriteKey = GlobalKey();
  GlobalKey<TemplateReminderPaymentsWidgetState> _remiderKey = GlobalKey();

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget get formWidget => Scaffold(
      appBar: AppBar(
        title: TextLocale('favorite'),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        actions: [
          if (favoriteList.length > 1)
            IconButton(
              key: const Key(WidgetIds.templatesPageSettings),
              icon: SvgPicture.asset(
                  'assets/graphics_redesign/no_shape_settings.svg'),
              onPressed: makeEditTemplateItems,
            )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ItemContainer(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: ItemContainer(
                    height: 36,
                    padding: const EdgeInsets.all(2),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    backgroundColor: ColorNode.Background,
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                          color: ColorNode.MainIcon,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: ColorNode.TextSecondary,
                      tabs: [
                        Tab(text: locale.getText('templates')),
                        Tab(text: locale.getText('by_schedule')),
                      ],
                    )),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    TemplateFavoritesWidget(inject(), key: _favoriteKey),
                    TemplateReminderPaymentsWidget(inject(), key: _remiderKey),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: ColorNode.GreyScale200,
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewPadding.bottom + 16,
              ),
              child: RoundedButton(
                key: const Key(WidgetIds.templatesPageCreateTemplate),
                title: 'create_template',
                onPressed: attemptAddNewTemplate,
              ),
            ),
          )
        ],
      ));

  Future<void> attemptAddNewTemplate() async {
    final PaymentParams? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryAndProvidersWidget(inject()),
      ),
    );

    if (result != null) {
      final attached = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddNewTemplatePage(paymentParams: result))) ??
          false;

      if (attached) {
        if (_tabCtrl.index == 0) {
          _favoriteKey.currentState?.updateFavorites();
        } else {
          _remiderKey.currentState?.updateRemiders();
        }
      }
    }
  }

  void makeEditTemplateItems() {
    if (_tabCtrl.index == 0) {
      _favoriteKey.currentState?.makeEditItems();
    } else {
      _remiderKey.currentState?.makeEditItems();
    }
  }
}
