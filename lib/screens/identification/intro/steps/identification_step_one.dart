import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/identification/identification_layout.dart';

import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one_wm.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/step_container_item.dart';

class IdentificationStepOne
    extends ElementaryWidget<IIdentificationStepOneWidgetModel> {
  static const Tag = '/identification_step_one';

  IdentificationStepOne({
    Key? key,
  }) : super(identificationStepOneWidgetModelFactory, key: key);

  @override
  Widget build(IIdentificationStepOneWidgetModel wm) => IdentificationLayout(
        showStep: true,
        currentStep: 1,
        buttonText: locale.getText('scan_doc'),
        title: locale.getText('iden_step_one_title'),
        subtitle: locale.getText('iden_step_one_subtitle'),
        containerTitle: locale.getText('iden_step_one_container_title'),
        containerChildren: Column(
          children: [
            StepContainerItem(
              title: locale.getText('doc_fit_border'),
            ),
            SizedBox(
              height: 4,
            ),
            StepContainerItem(
              title: locale.getText('element_visible'),
            ),
            SizedBox(
              height: 4,
            ),
            StepContainerItem(
              title: locale.getText('without_white'),
            ),
            SizedBox(
              height: 4,
            ),
            StepContainerItem(
              title: locale.getText('not_finger'),
            ),
            SizedBox(
              height: 4,
            ),
            StepContainerItem(
              title: locale.getText('camera_clear'),
            ),
          ],
        ),
        onTap: wm.onBottomSheet,
      );
}
