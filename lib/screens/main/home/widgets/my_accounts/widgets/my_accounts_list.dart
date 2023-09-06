import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/ui_models/rows/account_row_item.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:ui_kit/ui_kit.dart';

const _maxAmountCount = 5;

class MyAccountsList extends StatelessWidget {
  final List<PynetId> accountsData;
  final VoidCallback onOpenMyAccountsScreen;
  final Function(PynetId) onSingleAccountOpen;

  const MyAccountsList({
    required this.accountsData,
    required this.onOpenMyAccountsScreen,
    required this.onSingleAccountOpen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: const BoxDecoration(
        color: BackgroundColors.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: LocaleBuilder(
        builder: (_, locale) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_exceedsMaxCount)
              HeadlineV2.Counter(
                title: locale.getText('my_accounts'),
                count: accountsData.length,
                onTap: onOpenMyAccountsScreen,
              )
            else
              HeadlineV2.Chevron(
                title: locale.getText('my_accounts'),
                onTap: onOpenMyAccountsScreen,
              ),
            _shortAccountListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _shortAccountListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: min(_maxAmountCount, accountsData.length),
      itemBuilder: (_, index) => AccountItem(
        account: accountsData[index],
        onTap: onSingleAccountOpen,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
      ),
    );
  }

  bool get _exceedsMaxCount => accountsData.length > _maxAmountCount;
}
