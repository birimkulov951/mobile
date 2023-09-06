import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/utils/inject.dart';

import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one_model.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/action_sheet.dart';

abstract class IIdentificationStepOneWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin {
  void onBottomSheet();
}

class IdentificationStepOneWidgetModel
    extends WidgetModel<IdentificationStepOne, IdentificationStepOneModel>
    with
        SystemWidgetModelMixin<IdentificationStepOne,
            IdentificationStepOneModel>
    implements
        IIdentificationStepOneWidgetModel {
  IdentificationStepOneWidgetModel(IdentificationStepOneModel model)
      : super(model);

  @override
  void onBottomSheet() {
    ActionSheet.showActionSheet(
      context: context,
      title: locale.getText('choose_option'),
      subtitle: locale.getText('iden_step_one_title'),
      scanPassport: () => model.onScanPassport(context),
      scanId: () => model.onScanIdCard(context),
    );
  }
}

IdentificationStepOneWidgetModel identificationStepOneWidgetModelFactory(
        BuildContext context) =>
    IdentificationStepOneWidgetModel(IdentificationStepOneModel(
      inject(),
    ));
