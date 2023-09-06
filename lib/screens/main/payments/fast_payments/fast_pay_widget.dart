import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart' show db, locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/accounts/accounts_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/fast_payment_phone_widget.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/item/item_icon_text_container.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

final _ratioToWidthPercent = 0.079;

class FastPayWidget extends StatefulWidget {
  const FastPayWidget({
    required this.checkPermissions,
    required this.merchantRepository,
    required this.onQRRead,
    this.viewTitle = false,
    this.onGoPayments,
    this.backgroundColor = Colors.white,
    this.itemColor = ColorNode.Background,
    this.onGoToMyAccountsScreen,
    this.hideMyAccounts = false,
    this.containerPadding = const EdgeInsets.symmetric(vertical: 16),
  });

  final bool viewTitle;
  final VoidCallback? onGoPayments;

  //need to update home screen my accounts widget if something changes
  final VoidCallback? onGoToMyAccountsScreen;
  final ValueChanged<String> onQRRead;
  final Color backgroundColor;
  final Color itemColor;
  final Future<bool> Function(PermissionRequest request) checkPermissions;
  final bool hideMyAccounts;
  final EdgeInsets containerPadding;
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => FastPayWidgetState();
}

class FastPayWidgetState extends State<FastPayWidget> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleLayout,
          fastPayLayout,
        ],
      );

  Widget get titleLayout => Visibility(
        visible: widget.viewTitle,
        child: ListTile(
          dense: true,
          title: TextLocale(
            'fast_pay_title',
            style: TextStyles.title5,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: widget.onGoPayments,
        ),
      );

  Widget get fastPayLayout {
    final double size = ((MediaQuery.of(context).size.width / 3) - 15);

    return ItemContainer(
      padding: widget.containerPadding, // top and bottom summary must be 32.
      backgroundColor: widget.backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            SizedBox(width: 16),
            ItemIconTextContainer(
              icon: SvgPicture.asset(
                Assets.icOperationsMobile,
                color: ColorNode.MainIcon,
              ),
              title: 'mobile',
              width: size,
              height: size - (size * _ratioToWidthPercent),
              backgroundColor: widget.itemColor,
              onTap: _fastPay4Phone,
            ),
            SizedBox(width: 8),
            ItemIconTextContainer(
              icon: SvgPicture.asset(
                Assets.icActionScan,
                color: ColorNode.MainIcon,
              ),
              title: 'qr_pay',
              width: size,
              height: size - (size * _ratioToWidthPercent),
              backgroundColor: widget.itemColor,
              onTap: _qrPay,
            ),
            Visibility(
              visible: !widget.hideMyAccounts,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  ItemIconTextContainer(
                    icon: SvgPicture.asset(
                      Assets.home,
                      color: ColorNode.MainIcon,
                    ),
                    title: 'my_accounts',
                    width: size,
                    height: size - (size * _ratioToWidthPercent),
                    backgroundColor: widget.itemColor,
                    onTap: widget.onGoToMyAccountsScreen ?? _myAccounts,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            ItemIconTextContainer(
              icon: SvgPicture.asset(
                Assets.icOperationsFile,
                color: ColorNode.MainIcon,
              ),
              title: 'pay_by_requisites',
              width: size,
              height: size - (size * _ratioToWidthPercent),
              backgroundColor: widget.itemColor,
              onTap: _payByRequisites,
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _qrPay() async {
    if (!(await widget.checkPermissions(PermissionRequest.cameraQr()))) {
      return;
    }
    final result =
        await Navigator.pushNamed<dynamic>(context, TransferByQRScreen.Tag);

    if (result != null) {
      widget.onQRRead.call(result);
    }
  }

  Future<void> _fastPay4Phone() async {
    final merchant = widget.merchantRepository.findMerchant(7449);

    if (merchant == null) {
      showDialog(
        context: context,
        builder: (context) => showMessage(
          context,
          locale.getText('attention'),
          locale.getText('service_not_available'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FastPaymentWidget(merchant: merchant),
      ),
    );
  }

  void _myAccounts() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountsPage(widget.merchantRepository),
        ),
      );

  Future<void> _payByRequisites() async {
    final merchant = widget.merchantRepository.findMerchant(6710);

    if (merchant != null) {
      launchPaymentPage(
        paymentParams: PaymentParams(
          merchant: merchant,
          title: locale.getText('pay_by_requisites').replaceAll('\n', ' '),
        ),
      );
    }
  }
}
