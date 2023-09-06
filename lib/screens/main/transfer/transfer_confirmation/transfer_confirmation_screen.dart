import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_target_owner_type.dart';
import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_transfer_money_new.dart';
import 'package:mobile_ultra/screens/card/addition/sms_confirmation_disabled.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_confirmation/route/transfer_confirmation_screen_arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/card_item_transfer.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/transfer_result.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/transfer_verfy.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:sprintf/sprintf.dart';

/// Перевод на карту
class TransferConfirmationScreen extends StatefulWidget {
  static const Tag = '/transferConfirmationScreen';

  @override
  State<StatefulWidget> createState() => TransferConfirmationScreenState();
}

// todo refactor whole class
class TransferConfirmationScreenState
    extends BaseTransferMoneyNew<TransferConfirmationScreen> {
  bool _showLoading = false;

  AttachedCard? fromCard;
  String? amounts;
  String? keyComments;
  int? receiverCardTypes;
  double? commissionChange;
  double? commissionAmount;
  bool? _isOther;
  TransferDestinationType? _destinationType;
  String _comment = '';
  bool _isAddTemplateButtonHidden = false;
  String? _receiverCardIdentifier;

  @override
  void onThemeChanged() {}

  @override
  void initState() {
    super.initState();
    keyComments = null;
  }

  @override
  void dispose() {
    super.dispose();
    p2pResult = null;
  }

  @override
  Widget get formWidget {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as TransferConfirmationScreenArguments;

    fromCard = arguments.fromCard;
    p2pResult = arguments.p2pResult;
    amounts = arguments.amounts;
    keyComments = arguments.keyComments;
    receiverCardTypes = arguments.receiverCardTypes;
    commissionChange = arguments.commissionChange;
    commissionAmount = arguments.commissionAmount;
    _isOther = arguments.isOther;
    _destinationType = arguments.destinationType;
    _comment = arguments.comment;
    _isAddTemplateButtonHidden = arguments.isAddTemplateButtonHidden;
    _receiverCardIdentifier = arguments.receiverCardIdentifier;

    return Container(
      color: appTheme.backgroundColor,
      child: Scaffold(
          appBar: PaynetAppBar('payment_confirm'),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        locale.getText("where"),
                        style: TextStyles.captionButtonSecondary,
                      ),
                    ),
                    CardItem(
                      isSelected: false,
                      uCard: fromCard,
                      backgroundColor: ColorNode.Background,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        locale.getText("wheres"),
                        style: TextStyles.captionButtonSecondary,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    CardItemTransfer.fromSvg(
                      color: ColorNode.Background,
                      image: "assets/graphics_redesign/iconCard.svg",
                      text: p2pResult?.fio == null
                          ? locale.getText("card_or_phone_number")
                          : formatCardNumberSecondary(p2pResult?.pan ?? ''),
                      title: p2pResult == null
                          ? ""
                          : (p2pResult?.pan == null
                              ? locale.getText("card_or_phone_number")
                              : p2pResult?.fio ?? ''),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Visibility(
                      visible: keyComments != null,
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 12, left: 16, right: 16),
                          child: keyComments?.isNotEmpty ?? false
                              ? Text(
                                  locale.getText("comment"),
                                  style: TextStyle(
                                      color: ColorNode.Dark1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              : Container()),
                    ),
                    Visibility(
                      visible: keyComments != null,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 12, left: 16, right: 16),
                        child: Text(
                          keyComments ?? '',
                          style: TextStyle(
                              color: ColorNode.MainSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: Text(
                          locale.getText("transfer_amount"),
                          style: TextStyles.captionButton,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 18),
                        child: Text(
                          '${formatAmount(double.parse(amounts!))} ${locale.getText("sum")}',
                          style: TextStyles.title3SemiBold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Text(
                          sprintf(
                            locale.getText('commission_f'),
                            [
                              commissionChange,
                              formatAmount(commissionAmount),
                            ],
                          ),
                          style: TextStyles.caption1MainSecondary,
                        ),
                      ),
                      LocaleBuilder(
                        builder: (_, locale) => RoundedButton(
                            margin: EdgeInsets.fromLTRB(16, 16, 16,
                                MediaQuery.of(context).viewPadding.bottom + 16),
                            title:
                                "${locale.getText('transfer_money')} ${formatAmount(double.parse(amounts!))} ${locale.getText('sum')}",
                            loading: _showLoading,
                            onPressed: _showLoading ? null : attemptTransfer),
                      ),
                    ],
                  ),
                ),
              ),
              LoadingWidget(showLoading: _showLoading),
            ],
          )),
    );
  }

  @override
  Future onError(String error, {dynamic errorBody}) async {
    _onLoad();

    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final errResp = RequestError.fromJson(errorBody);
      if (errResp.status == 400 &&
          errResp.detail == 'not_card_owner_sms_sent') {
        final result = fromCard == null
            ? null
            : await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransferVerify(
                    id: int.parse(errResp.id ?? ''),
                    card: fromCard!,
                  ),
                ),
              );

        if (result != null) {
          onP2PResult(result);
        }
      } else {
        await super.onError(errResp.title ?? '', errorBody: errorBody);
        Navigator.pop(context, false);
      }
    } else {
      await super.onError(error, errorBody: errorBody);
      Navigator.pop(context, false);
    }
  }

  @override
  void attemptTransfer({
    String? cardToken,
    int? cardType,
    int? amount,
    String? receiverCardIdentifier,
    int? receiverCardTypes,
  }) {
    _onLoad(loading: true);

    final parsedAmount = int.parse(amounts ?? '');

    AnalyticsInteractor.instance.transfersOutTracker.trackConfirmed(
      targetType: (_isOther ?? false)
          ? TransferTargetOwnerType.other
          : TransferTargetOwnerType.myself,
      source: getTransferSourceTypesByInt(fromCard?.type),
      destinationType: _destinationType,
      amount: parsedAmount,
      isEnteredComment: _comment.isNotEmpty,
    );

    if (fromCard?.sms ?? false) {
      super.attemptTransfer(
        cardToken: fromCard?.token,
        cardType: fromCard?.type,
        amount: parsedAmount,
        receiverCardIdentifier: _receiverCardIdentifier,
      );
    } else {
      onSmsConfirmationDisabled();
    }
  }

  @override
  void onP2PResult(P2Pay result) {
    _onLoad(loading: false);

    Future.delayed(Duration(milliseconds: 100), () async {
      Navigator.pop(
        context,
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferResultWidget(
              p2pay: result,
              cardType: fromCard?.type,
              destinationType: _destinationType,
              commissionAmount: commissionAmount,
              comment: _comment,
              isOther: _isOther,
              receiverFio: p2pResult?.fio,
              canBeAddedToFavorites: _isAddTemplateButtonHidden,
            ),
          ),
        ),
      );
    });
  }

  void _onLoad({bool loading = false}) => setState(() {
        _showLoading = loading;
      });

  void onSmsConfirmationDisabled() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CardSMSConfirmationDisabledWidget()))
        .then((value) => _onLoad(loading: false));
  }
}
