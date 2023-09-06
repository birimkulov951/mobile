import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';

class MostCommonPaymentPage extends StatefulWidget {
  final PaymentParams paymentParams;

  const MostCommonPaymentPage({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => MostCommonPaymentPageState();
}

class MostCommonPaymentPageState
    extends BasePaymentPageState<MostCommonPaymentPage> {
  @override
  void initState() {
    this.paymentParams = widget.paymentParams;

    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () => makeDynamicFields(),
    );

    AnalyticsInteractor.instance.paymentTracker.trackOpened(
      source: paymentParams?.paymentOpenedSource,
      merchantId: paymentParams?.merchant?.id,
    );
  }

  @override
  String get buttonTitle => locale.getText('continue');

  @override
  bool get enabledFields => true;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PynetAppBar(
              paymentParams?.title ?? '',
            ),
            body: scrolledForm,
          ),
          LoadingWidget(
            showLoading: blockBtn,
          ),
        ],
      );

  @override
  void onChangeCurrentCard(AttachedCard? card) {
    super.onChangeCurrentCard(card);
    AnalyticsInteractor.instance.paymentTracker.trackSelected(
      source: getTransferSourceTypesByInt(card?.type),
    );
  }
}
