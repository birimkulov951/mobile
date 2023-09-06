import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/payment_verification.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';
import 'package:mobile_ultra/utils/route_utils.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

enum PaymentVerifyType {
  PAYMENT,
  P2P,
}

// todo remove!
class PaymentVerificationWidget extends StatefulWidget {
  static const Tag = '/paymentVerification';

  @override
  State<StatefulWidget> createState() => PaymentVerificationWidgetState();
}

class PaymentVerificationWidgetState
    extends BaseSMSConfirmLayout<PaymentVerificationWidget>
    with PaymentVerificationView {
  PaymentVerifyType? _payType;
  dynamic _id;
  AttachedCard? _card;

  @override
  Widget get formWidget {
    if (_payType == null) {
      final List<dynamic>? arguments = getListArgumentFromContext(context);
      _id = arguments?[0];
      _card = arguments?[1];
      _payType = arguments?[2];
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: TextLocale('confirm'),
            titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          body: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: TextLocale(
                    'confirm_sms_code',
                    style: appTheme.textTheme.bodyText2
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextLocale(
                  'hint_5',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                formatStarsPhone(_card?.phone),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox() //getInputLayout,
                  ),
              Text(
                timeLeft,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        //LoadingWidget(showLoading: showLoading),
      ],
    );
  }

  void onShowLoading() => setState(() {
        //showLoading = true
      });

  void onShowContent() {
    /*if (mounted)
      setState(() => showLoading = false);*/
  }

  @override
  void onConfirmOTP({String? otp}) {
    //super.onConfirmOTP(otp: otp);

    Future.delayed(Duration(milliseconds: 200), () {
      onShowLoading();

      Map<String, dynamic> requestData = {
        'otp': otp,
      };

      switch (_payType) {
        case PaymentVerifyType.PAYMENT:
          requestData['billId'] = _id;
          requestData['token'] = _card?.token;

          if (_card?.type == 4)
            PaymentVerificationPresenter.verifyHumo(this).verify(requestData);
          else
            PaymentVerificationPresenter.verifyUzcard(this).verify(requestData);
          break;
        case PaymentVerifyType.P2P:
          requestData['id'] = _id;
          PaymentVerificationPresenter.verifyP2P(this).verify(requestData);
          break;
        default:
          break;
      }
    });
  }

  void onError(String error, dynamic errorBody) {
    onShowContent();
    String message = error;

    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final errResp = RequestError.fromJson(errorBody);

      if (errResp.status == 400 && errResp.detail == 'invalid_code_retry')
        message = locale.getText(
            errResp.left == '0' ? 'entry_count_limit_exceeded' : 'wrong_code');
    }

    onFail(message,errorBody: errorBody);
  }

  @override
  void onPayVerifyError(String error, errorBody) => onError(
        error,
        errorBody,
      );

  @override
  void onPayVerifySuccess(dynamic result) => Navigator.pop(context, result);

  @override
  String get subtitle => throw UnimplementedError();

  @override
  String get title => throw UnimplementedError();

  @override
  String get subtitleSpan => throw UnimplementedError();
}
