import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/net/identification/identification_presenter.dart';
import 'package:mobile_ultra/net/identification/modal/passport_data.dart';
import 'package:mobile_ultra/screens/identification/identification_layout.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/rejected_message/identification_rejected_page.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/sucsess_message/identification_sucsess_page.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/selfie_photo.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/step_container_item.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/try_again_message/identification_try_again_page.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/utils/u.dart';

import 'package:mrz_parser/mrz_parser.dart';

class IdentificationStepTwo extends StatefulWidget {
  static const Tag = '/Identification_step_two';

  const IdentificationStepTwo({Key? key}) : super(key: key);

  @override
  IdentificationStepTwoState createState() => IdentificationStepTwoState();
}

class IdentificationStepTwoState
    extends BaseInheritedTheme<IdentificationStepTwo> with IdentificationView {
  bool identificationLoading = false;
  MRZResult? args;

  Future<void> getCardInfo({
    String? passportNumber,
    String? pinfl,
    String? photoBase64,
  }) async {
    PassportData passportData = PassportData(
      passportNumber: passportNumber,
      pinfl: pinfl,
      photoBase64: photoBase64,
    );
    IdentificationPresenter.identification(this).postPassportData(
      passportData: passportData,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as MRZResult?;
  }

  @override
  Future<void> onIdentification({
    String? error,
    errorBody,
    bool? status,
  }) async {
    printLog('Selfie errorBody: $errorBody');

    if ("The user has already been identified" == error || status == true) {
      setState(() {
        identificationLoading = false;
      });

      AnalyticsInteractor.instance.verificationTracker.trackSelfiePassed();

      AnalyticsInteractor.instance.verificationTracker
          .trackFinished(VerificationResults.success);

      Navigator.pushReplacementNamed(context, IdentificationSuccessPage.Tag);
    } else if (errorBody.toString().contains('status') &&
        errorBody['status'] == 500) {
      AnalyticsInteractor.instance.verificationTracker
          .trackFinished(VerificationResults.serviceDown);

      identificationLoading = false;
      Navigator.pushReplacementNamed(context, IdentificationRejectedPage.Tag);
    } else if (status == false &&
        errorBody.toString().contains('status') &&
        errorBody['status'] != 500) {
      AnalyticsInteractor.instance.verificationTracker
          .trackFinished(VerificationResults.fail);

      identificationLoading = false;
      Navigator.pushReplacementNamed(context, IdentificationtryAgainpage.Tag);
    } else {
      AnalyticsInteractor.instance.verificationTracker
          .trackFinished(VerificationResults.fail);

      identificationLoading = false;
      Navigator.pushReplacementNamed(context, IdentificationtryAgainpage.Tag);
    }
  }

  @override
  Widget get formWidget => identificationLoading
      ? LoadingWidget(
          showLoading: identificationLoading,
          withProgress: true,
        )
      : IdentificationLayout(
          showStep: true,
          currentStep: 2,
          title: locale.getText('iden_step_two_title'),
          subtitle: locale.getText('iden_step_two_subtitle'),
          containerTitle: locale.getText('iden_step_two_container_title'),
          containerChildren: Column(
            children: [
              StepContainerItem(
                title: locale.getText('oval_photo_text'),
              ),
              SizedBox(height: 4),
              StepContainerItem(
                title: locale.getText('face_clear'),
              ),
              SizedBox(height: 4),
              StepContainerItem(
                title: locale.getText('monotonous_background'),
              ),
              SizedBox(height: 4),
              StepContainerItem(
                title: locale.getText('camera_clear'),
              ),
            ],
          ),
          buttonText: locale.getText('take_selfie'),
          onTap: () async {
            final result =
                await Navigator.pushNamed(context, SelfiePhotoPage.Tag);
            if (result != false && result != null) {
              setState(() {
                identificationLoading = true;
              });
              await getCardInfo(
                pinfl: args!.personalNumber,
                passportNumber: args!.documentNumber,
                photoBase64: result is String? ? result as String? : null,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        );
}
