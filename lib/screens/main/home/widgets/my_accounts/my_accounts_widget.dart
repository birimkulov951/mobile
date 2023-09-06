import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/payment/model/paynetid.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/widgets/my_accounts_empty_widget.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/widgets/my_accounts_list.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/widgets/my_accounts_shimmer.dart';

class MyAccountsWidget extends StatelessWidget {
  final VoidCallback onAccountAddTap;
  final VoidCallback onMyAccountTextTap;
  final Function(PaynetId) onSingleAccountOpen;
  final EntityStateNotifier<List<PaynetId>?> myAccountsList;

  const MyAccountsWidget({
    required this.onAccountAddTap,
    required this.onMyAccountTextTap,
    required this.onSingleAccountOpen,
    required this.myAccountsList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<List<PaynetId>?>(
      listenableEntityState: myAccountsList,
      builder: (_, accountsData) {
        if (accountsData == null) {
          return const SizedBox();
        } else if (accountsData.isEmpty) {
          return MyAccountsEmptyWidget(onAccountAddTap: onAccountAddTap);
        }

        return MyAccountsList(
          accountsData: accountsData,
          onOpenMyAccountsScreen: onMyAccountTextTap,
          onSingleAccountOpen: onSingleAccountOpen,
        );
      },
      loadingBuilder: (_, __) => MyAccountsShimmer(
        onOpenMyAccountsScreen: onMyAccountTextTap,
      ),
    );
  }
}
