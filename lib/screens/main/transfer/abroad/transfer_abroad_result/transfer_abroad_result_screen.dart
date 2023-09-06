import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/transfer_abroad_result_screen_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/widgets/transfer_abroad_result_fail.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/widgets/transfer_abroad_result_success.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/widgets/transfer_abroad_result_time_out.dart';

import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/arguments.dart';

class TransferAbroadResultScreen
    extends ElementaryWidget<ITransferAbroadResultScreenWidgetModel> {
  final TransferAbroadResultScreenArguments arguments;

  const TransferAbroadResultScreen({
    Key? key,
    required this.arguments,
  }) : super(transferAbroadResultScreenWidgetModelFactory, key: key);

  @override
  Widget build(ITransferAbroadResultScreenWidgetModel wm) {
    Widget child;
    switch (arguments.resultStatus) {
      case TransferAbroadResultStatus.success:
        child = TransferAbroadResultSuccess(
            amountPaid: wm.amountPaid,
            commission: wm.commission,
            onRepeatCurrentTransferTap: wm.repeatTransfer,
            onTransferDetailsButtonTap: wm.openTransferDetailsBottomSheet,
            onReturnToMain: wm.returnToMain);
        break;
      case TransferAbroadResultStatus.fail:
        child = TransferAbroadResultFail(onReturnToMain: wm.returnToMain);
        break;
      case TransferAbroadResultStatus.timeOut:
        child = TransferAbroadResultTimeOut(onPopBack: wm.popBack);
        break;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: child,
    );
  }
}
