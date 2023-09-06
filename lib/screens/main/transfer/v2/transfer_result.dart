import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_target_owner_type.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/history/modal/history.dart' as h;
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/history/widgets/card_detail_btm_sheet.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/buttons/vertical_icon_button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/utils/u.dart';

const _delayDuration = const Duration(milliseconds: 300);
const _percentage = 100;

enum TransferResultAction {
  PayAgain,
  Close,
  Home,
}

class TransferResultWidget extends StatefulWidget {
  static const Tag = '/transferResult';

  const TransferResultWidget({
    Key? key,
    this.p2pay,
    this.cardType,
    this.destinationType,
    this.commissionAmount,
    this.comment,
    this.isOther,
    this.receiverFio,
    this.canBeAddedToFavorites = false,
  }) : super(key: key);

  final P2Pay? p2pay;
  final int? cardType;
  final TransferDestinationType? destinationType;
  final double? commissionAmount;
  final String? comment;
  final bool? isOther;
  final String? receiverFio;
  final bool canBeAddedToFavorites;

  @override
  State<StatefulWidget> createState() => TransferResultWidgetState();
}

class TransferResultWidgetState
    extends BaseInheritedTheme<TransferResultWidget> {
  bool _isAddTemplateButtonHidden = false;
  bool _isAddTemplateButtonDisabled = false;

  @override
  void onThemeChanged() {}

  @override
  void initState() {
    super.initState();

    _isAddTemplateButtonHidden = widget.canBeAddedToFavorites;

    Future.delayed(_delayDuration).then((value) {
      AnalyticsInteractor.instance.transfersOutTracker.trackTransferSuccess(
        ownerType: (widget.isOther ?? false)
            ? TransferTargetOwnerType.other
            : TransferTargetOwnerType.myself,
        source: getTransferSourceTypesByInt(widget.cardType),
        destinationType: widget.destinationType,
        amount: widget.p2pay?.amount,
        comission: widget.commissionAmount,
        isEnteredComment: widget.comment?.isNotEmpty ?? false,
      );
    });
  }

  @override
  Widget get formWidget => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, TransferResultAction.Home);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).viewPadding.top),
                    SvgPicture.asset(Assets.success),
                    SizedBox(height: 20),
                    Text(
                      locale.getText("transfer_sent"),
                      style: TextStyles.title5,
                    ),
                    SizedBox(height: 20),
                    Text(
                      creditAmount(),
                      style: TextStyles.title1,
                    ),
                    SizedBox(height: 4),
                    Text(
                      commissionAmount(),
                      style: TextStyles.caption1MainSecondary,
                    ),
                  ],
                ),
              ),
              ItemContainer(
                padding: EdgeInsets.only(
                  left: 16,
                  top: 24,
                  right: 16,
                  bottom: 16,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                backgroundColor: ColorNode.Background,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (!_isAddTemplateButtonHidden)
                          VerticalIconButton(
                            key: const Key(WidgetIds.transferResultAddToFavorites),
                            textColor: Colors.black,
                            title: 'add_to_favorites',
                            onTap: onAttemptToAddFavorite,
                            child: SvgPicture.asset(
                              Assets.add,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                        VerticalIconButton(
                          key: const Key(WidgetIds.transferResultDetails),
                          textColor: Colors.black,
                          title: 'payment_details',
                          child: SvgPicture.asset(
                            Assets.cheque,
                            height: 24,
                            color: Colors.white,
                          ),
                          onTap: onShowBottomSheet,
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    RoundedButton(
                      key: const Key(WidgetIds.transferResultSuccess),
                      title: 'done',
                      onPressed: () =>
                          Navigator.pop(context, TransferResultAction.Home),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void onShowBottomSheet() {
    final h.HistoryResponse historyItem = h.HistoryResponse(
      id: widget.p2pay?.id,
      pan: widget.p2pay?.pan ?? widget.p2pay?.pan1,
      tranType: widget.p2pay?.tranType ?? TranType.p2p.value,
      amount: widget.p2pay?.amount,
      date7: widget.p2pay?.issuedDate,
      dcreated: widget.p2pay?.dcreated,
      stan: widget.p2pay?.stan,
      expiry: widget.p2pay?.expiry,
      refNum: widget.p2pay?.refNum,
      merchantId: widget.p2pay?.merchantId,
      terminalId: widget.p2pay?.terminalId,
      currency: widget.p2pay?.currency,
      resp: widget.p2pay?.resp,
      status: "OK",
      login: widget.p2pay?.login,
      card1: widget.p2pay?.card1,
      merchantName: locale.getText('money_p2p'),
      humoPaymentRef: widget.p2pay?.humoPaymentRef,
      pan2: widget.p2pay?.pan2,
      commission: widget.p2pay?.commission,
      fio: widget.p2pay?.fio,
      amountCredit: widget.p2pay?.amountCredit,
      additionalInfo: null,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorNode.Background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => CardDetailBtmSheet(
        historyItem: historyItem,
        hasShareIcon: true,
        hasQr: false,
        hasUserCode: true,
      ),
    );
  }

  void onAttemptToAddFavorite() async {
    if (_isAddTemplateButtonDisabled) {
      return;
    }
    setState(() => _isAddTemplateButtonDisabled = true);

    FavoritePresenter.newFavorite(
      data: {
        'name': transferTemplateName(widget.receiverFio, widget.p2pay?.pan2),
        'tranId': widget.p2pay?.id,
      },
      onFail: _onFavoriteFail,
      onSuccess: _onFavoriteSuccess,
    );
  }

  void _onFavoriteFail(String error, errorBody) {
    setState(() => _isAddTemplateButtonDisabled = false);
    onFail(
      locale.getText('no_added'),
    );
  }

  void _onFavoriteSuccess({data}) => FavoritePresenter.favorites(
        data: {
          'page': '0',
          'size': '1000',
        },
        onSuccess: ({data}) {
          Toast.show(
            context,
            title: locale.getText('payment_saved_success'),
            type: ToastType.success,
            hasTopPadding: false,
          );
          setState(() {
            _isAddTemplateButtonHidden = true;
            _isAddTemplateButtonDisabled = false;
          });
        },
      );

  void onFail(String message) => showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
          context,
          locale.getText('error'),
          message,
          onSuccess: () => Navigator.pop(context),
        ),
      );

  String creditAmount() {
    final amount = (((widget.p2pay?.amountCredit ?? 0) / _percentage).round());

    return '${formatAmount(amount.toDouble())} ${locale.getText("sum")}';
  }

  String commissionAmount() {
    if (widget.p2pay?.amount == null) return locale.getText("no_commission");

    final amount = ((widget.p2pay!.amount - (widget.p2pay?.amountCredit ?? 0)) /
        _percentage);

    return '${locale.getText('comission')} ${formatAmount(amount.toDouble())} ${locale.getText("sum")}';
  }
}
