import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/home/home_screen_wm.dart';
import 'package:mobile_ultra/screens/main/home/widgets/cards/cards_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/cashback_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/home_screen_header.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/my_accounts_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_balance_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/news_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/quick_actions_widget.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class HomeScreen extends ElementaryWidget<IHomeScreenWidgetModel> {
  const HomeScreen({
    required this.onQReadResult,
    required this.onGoHistory,
    required this.onProfile,
    super.key,
  }) : super(homeScreenWidgetModelFactory);

  final ValueChanged<String> onQReadResult;
  final VoidCallback onGoHistory;
  final Future<void> Function() onProfile;

  @override
  Widget build(IHomeScreenWidgetModel wm) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: IconAndOtherColors.accent,
          onRefresh: wm.refreshHomeScreen,
          child: ValueListenableBuilder<bool>(
            valueListenable: wm.isBalanceHidden,
            builder: (_, isBalanceHidden, ___) => ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                RoundedButton(
                  title: 'Request permissons',
                  onPressed: () {
                   /* AppMetricaPush.requestPermission(
                        alert: true, badge: true, sound: true);*/
                  },
                ),
                RoundedButton(
                  title: 'Start token listening',
                  onPressed: () {
                   /* AppMetricaPush.tokenStream.listen((tokens) {
                      // handle new tokens
                      print('APP METRICA TOKENS $tokens');
                    });*/
                  },
                ),
                RoundedButton(
                  title: 'Request tokens',
                  onPressed: () async {
                    //final tokens = await AppMetricaPush.getTokens();
                    //print('REQUESTED TOKENS $tokens');
                  },
                ),
                HomeScreenHeader(
                  phoneNumber: wm.phoneNumber,
                  onProfileTap: onProfile,
                  onNotificationTap: wm.onNotificationsTap,
                  onSupportTap: wm.onSupportTap,
                ),
                const SizedBox(height: 24.0),
                MyBalanceWidget(
                  flipBalanceVisibility: wm.flipBalanceVisibility,
                  isBalanceHidden: isBalanceHidden,
                  allCardsData: wm.allCardsData,
                ),
                const SizedBox(height: 24.0),
                CashbackWidget(
                  isBalanceHidden: isBalanceHidden,
                  weeklyCashback: wm.weeklyCashback,
                  monthlyCashback: wm.monthlyCashback,
                ),
                const SizedBox(height: 12.0),
                QuickActionsWidget(
                  onQRPaymentTap: wm.onQRPaymentTap,
                  onRequisitePaymentTap: wm.onRequisitePaymentTap,
                  onFastPaymentTap: wm.onFastPaymentTap,
                ),
                const SizedBox(height: 12.0),
                NewsWidget(
                  news: wm.news,
                  dismissNotification: wm.dismissNotification,
                  onNotificationTap: wm.onNotificationTap,
                ),
                CardsWidget(
                  attachNewCard: wm.openCardAddScreen,
                  warningText: wm.warningText,
                  getPaynetUCards: wm.getAttachedCards,
                  openAllCards: wm.openAllCardsScreen,
                  hideBalance: isBalanceHidden,
                  onEditCard: wm.openCardEditScreen,
                  allCardsData: wm.allCardsData,
                ),
                const SizedBox(height: 12.0),
                MyAccountsWidget(
                  onAccountAddTap: wm.addNewAccount,
                  onMyAccountTextTap: wm.goToMyAccountsScreen,
                  onSingleAccountOpen: wm.openChosenAccountDetailsScreen,
                  myAccountsList: wm.myAccountsList,
                ),
                const SizedBox(height: 64.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
