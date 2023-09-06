import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_wm.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one.dart';
import 'package:mobile_ultra/utils/inject.dart';

import 'package:mobile_ultra/screens/identification/intro/identification_intro.dart';
import 'package:mobile_ultra/screens/identification/intro/identification_intro_model.dart';

abstract class IIdentificationIntroWidgetModel extends IWidgetModel
    with IRemoteConfigWidgetModelMixin {
  void toIdentificationStepOne();
}

class IdentificationIntroWidgetModel
    extends WidgetModel<IdentificationIntro, IdentificationIntroModel>
    with
        RemoteConfigWidgetModelMixin<IdentificationIntro,
            IdentificationIntroModel>
    implements
        IIdentificationIntroWidgetModel {
  IdentificationIntroWidgetModel(model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    AnalyticsInteractor.instance.verificationTracker.trackInfoOpened();
    fetchRemoteConfig();
  }

  @override
  void toIdentificationStepOne() {
    Navigator.of(context).pushNamed(IdentificationStepOne.Tag);
  }
}

IdentificationIntroWidgetModel identificationIntroWidgetModelFactory(
        BuildContext context) =>
    IdentificationIntroWidgetModel(IdentificationIntroModel(inject()));
