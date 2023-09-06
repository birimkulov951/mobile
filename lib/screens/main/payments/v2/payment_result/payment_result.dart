import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart' show favoriteList, locale;
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/bill.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/widgets/payment_details_bottom_sheet.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/vertical_icon_button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/rows/provider_bonus_layout.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:sprintf/sprintf.dart';

const _circleImageSize = 76.0;
const _percentage = 100;

/// Фрагмент (сообщение) о результате выполнения операции по оплате
/// arguments: [0] - payment instance; [1] - merchant

enum PaymentResultAction {
  PayAgain,
  Close,
}

class PaymentResultWidget extends StatefulWidget {
  final Payment? payment;
  final MerchantEntity? merchant;
  final Bill? bill;
  final int? cardType;
  final bool isFastPay;

  const PaymentResultWidget({
    required this.payment,
    required this.merchant,
    required this.bill,
    required this.cardType,
    required this.isFastPay,
  });

  @override
  State<StatefulWidget> createState() => PaymentResultWidgetState();
}

class PaymentResultWidgetState extends BaseInheritedTheme<PaymentResultWidget> {
  void onAttemptToAddFavorite() async {
    FavoritePresenter.lastTrans(
      id: widget.payment!.id,
      onFail: _onFavoriteFail,
      onGetLastTrans: _onGetLastTrans,
    );
  }

  @override
  void initState() {
    super.initState();
    AnalyticsInteractor.instance.paymentTracker.trackSuccess(
      source: getTransferSourceTypesByInt(widget.cardType),
      merchantId: widget.merchant?.id,
      amount: widget.bill?.amount,
      isFastPay: widget.isFastPay,
    );
  }

  void onFail(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
        context,
        locale.getText('error'),
        message,
        onSuccess: () => Navigator.pop(context),
      ),
    );
  }

  void _onGetLastTrans({data}) => FavoritePresenter.newFavorite(
        data: {
          'billId': data.billId,
          'name': "",
        },
        onFail: _onFavoriteFail,
        onSuccess: _onFavoriteSuccess,
      );

  void _onFavoriteFail(String error, errorBody) => onFail(
        locale.getText('no_added'),
      );

  void _onFavoriteSuccess({data}) {
    FavoritePresenter.favorites(
      data: {
        'page': '0',
        'size': '1000',
      },
      onSuccess: ({data}) {
        Toast.show(
          context,
          title: locale.getText('payment_saved_success'),
          type: ToastType.success,
        );
        setState(() {});
      },
    );
  }

  @override
  Widget get formWidget => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, PaymentResultAction.Close);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: double.maxFinite,
            child: Column(
              children: [
                const Spacer(),
                CircleImage(
                  size: _circleImageSize,
                  merchantId: widget.merchant?.id,
                ),
                SizedBox(height: 24),
                Text(
                  _paymentStatus(),
                  textAlign: TextAlign.center,
                  style: TextStyles.title5.copyWith(
                    color: widget.payment?.resp == 0
                        ? ColorNode.Dark3
                        : ColorNode.Red,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  _paymentAmount(),
                  textAlign: TextAlign.center,
                  style: TextStyles.title1,
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: widget.payment?.bonus.isNotEmpty ?? false,
                  child: ProviderBonusLayout(
                    value: sprintf(locale.getText('amount_format'),
                        ['+${widget.payment?.bonus}']),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                ItemContainer(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 24,
                    right: 16,
                    bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  backgroundColor: ColorNode.Background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          if (favoriteList
                              .any((e) => e.billId == widget.bill?.id)) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                VerticalIconButton(
                                  key: const Key(WidgetIds.paymentResultDetails),
                                  textColor: Colors.black,
                                  title: 'payment_details',
                                  onTap: _showPaymentDetails,
                                  child: SvgPicture.asset(
                                    Assets.cheque,
                                    height: 21,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              VerticalIconButton(
                                key: const Key(WidgetIds.paymentResultAddToFavorites),
                                textColor: Colors.black,
                                title: 'add_to_favorites',
                                onTap: onAttemptToAddFavorite,
                                child: SvgPicture.asset(
                                  Assets.add,
                                  height: 18,
                                  color: Colors.white,
                                ),
                              ),
                              VerticalIconButton(
                                key: const Key(WidgetIds.paymentResultDetails),
                                textColor: Colors.black,
                                title: 'payment_details',
                                onTap: _showPaymentDetails,
                                child: SvgPicture.asset(
                                  Assets.cheque,
                                  height: 21,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 28),
                      RoundedButton(
                        key: const Key(WidgetIds.paymentResultSuccess),
                        title: 'done',
                        onPressed: () =>
                            Navigator.pop(context, PaymentResultAction.Close),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  String _paymentStatus() =>
      locale.getText(widget.payment?.resp == 0 ? 'pay_success' : 'pay_fail');

  String _paymentAmount() => sprintf(locale.getText('amount_format'), [
        formatAmount((widget.payment?.amount ?? 0) / _percentage),
      ]);

  void _showPaymentDetails() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: ColorNode.Background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (_) => PaymentDetailsBottomSheet(
          payment: widget.payment,
          hasShareIcon: true,
          hasQr: widget.payment?.mobileQrDto?.qrCodeUrl != null,
          hasUserCode: true,
        ),
      );
}
