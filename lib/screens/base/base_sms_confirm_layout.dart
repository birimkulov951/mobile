import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:android_sms_retriever/android_sms_retriever.dart';

import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/pin_code_field.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:sprintf/sprintf.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

abstract class BaseSMSConfirmLayout<T extends StatefulWidget>
    extends BaseInheritedTheme<T> {
  String timeLeft = '';
  String phone = '';
  String token = '';

  int? type;

  DateTime? _dateTime;
  Timer? _timer;

  TextEditingController? textEditingController;

  String _appSignature = "";

  bool _loading = false;
  bool _canResetOTP = false;
  bool _isListenSmsRetriever = false;
  bool _isInvalidCode = false;

  String _btnText = '';

  String get title;

  String get subtitle;

  String get subtitleSpan;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    if (Platform.isAndroid) {
      AndroidSmsRetriever.getAppSignature().then(
        (value) => _appSignature = value ?? 'Signature Not Found',
      );
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();

    if (Platform.isAndroid) {
      AndroidSmsRetriever.stopSmsListener();
    }
    super.dispose();
  }

  @override
  Widget get formWidget {
    final subtitleList = subtitle.split('%s');
    subtitleList.removeWhere((subtitleItem) => subtitleItem.isEmpty);

    return Stack(
      children: [
        Scaffold(
          appBar: PaynetAppBar(
            '',
            backgroundColor: ColorNode.ContainerColor,
          ),
          body: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: ColorNode.ContainerColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextLocale(
                    title,
                    style: TextStyles.title2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 28,
                      bottom: 24,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: subtitleList[0],
                        style: TextStyles.textRegular,
                        children: <TextSpan>[
                          TextSpan(
                            text: subtitleSpan,
                            style: TextStyles.textBold,
                          ),
                          if (subtitleList.length > 1)
                            TextSpan(
                              text: subtitleList[1],
                              style: TextStyles.textRegular,
                            ),
                        ],
                      ),
                    ),
                  ),
                  PinCodeTextField(
                    key: const Key(WidgetIds.smsConfirmInput),
                    length: 6,
                    isSeparated: true,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    mainAxisAlignment: MainAxisAlignment.center,
                    keyboardType: TextInputType.number,
                    cursorColor: ColorNode.Green,
                    autoFocus: true,
                    autoDismissKeyboard: false,
                    useHapticFeedback: false,
                    textStyle: TextStyles.textInputBold.copyWith(
                      color: _isInvalidCode ? ColorNode.Red : ColorNode.Dark1,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 60,
                      fieldWidth: 38,
                    ),
                    animationDuration: const Duration(milliseconds: 100),
                    enableActiveFill: true,
                    backgroundColor: ColorNode.ContainerColor,
                    controller: textEditingController,
                    onCompleted: onCompletedEnterOtp,
                    onChanged: (value) => setState(() {
                      if (_isInvalidCode) {
                        _isInvalidCode = false;
                        Future.delayed(Duration(milliseconds: 100), () {
                          textEditingController?.clear();
                        });
                      }
                    }),
                    beforeTextPaste: (text) {
                      return text != null
                          ? text.isNotEmpty && RegExp(r'^\d+$').hasMatch(text)
                          : false;
                    },
                    //DialogConfig:
                    appContext: context,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: Visibility(
                      visible: _isInvalidCode,
                      child: TextLocale(
                        'wrong_code_2',
                        style: TextStyles.caption1.copyWith(
                          color: ColorNode.Red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingWidget(
          showLoading: _loading,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: RoundedButton(
            key: const Key(WidgetIds.smsConfirmAndResetButton),
            title: _btnText,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewPadding.bottom + 16,
            ),
            loading: _loading,
            onPressed: _canResetOTP ? () => onPressResetOtp() : null,
          ),
        ),
      ],
    );
  }

  @mustCallSuper
  void onPressResetOtp() {
    onRequestOTP();
  }

  void startTimer() {
    _canResetOTP = false;
    onLoad();

    _dateTime = DateTime.now().add(Duration(minutes: 1));

    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (mounted) {
        setState(() {
          final now = DateTime.now();

          final Duration duration = _dateTime!.difference(now);

          if (duration.inSeconds == 0) {
            time.cancel();
            _canResetOTP = true;
            _btnText = locale.getText('resend_sms_code');
          } else {
            _btnText = sprintf(locale.getText('resend_sms_code_in'),
                [duration.inSeconds % 60]);
          }
        });
      }
    });

    if (Platform.isAndroid && !_isListenSmsRetriever) {
      _isListenSmsRetriever = true;

      AndroidSmsRetriever.listenForSms().then((dynamic value) async {
        if (value != null) {
          int _pos = value.indexOf(_appSignature);
          if (_pos != -1) {
            String _otp = value.substring(_pos - 7, _pos - 1);
            printLog('Sms code: $_otp');

            if (_otp.isNotEmpty) {
              setState(() {
                textEditingController?.text = _otp;
              });
            }
          }
        }
      });
    }
    onLoadEnd();
  }

  void onFail(String error, {dynamic errorBody}) async {
    if (errorBody.toString().contains('invalid_code_retry') ||
        errorBody.toString().contains('otp_is_not_correct')) {
      setState(() {
        _isInvalidCode = true;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => showMessage(
          context,
          locale.getText('error'),
          error,
          onSuccess: () => Navigator.pop(context),
        ),
      );
    }
  }

  void onLoad() => setState(() => _loading = true);

  void onLoadEnd() => setState(() => _loading = false);

  void onRequestOTP() {
    startTimer();
  }

  void onConfirmOTP({String? otp});

  @mustCallSuper
  void onCompletedEnterOtp(value) {
    onConfirmOTP(otp: value);
  }
}
