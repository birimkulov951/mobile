import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/remote_config/remote_config_entity.dart';
import 'package:mobile_ultra/screens/identification/identification_layout.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';

import 'package:mobile_ultra/screens/identification/intro/identification_intro_wm.dart';
import 'package:mobile_ultra/screens/identification/intro/widgets/container_item.dart';

class IdentificationIntro
    extends ElementaryWidget<IIdentificationIntroWidgetModel> {
  static const Tag = '/identification_intro';

  const IdentificationIntro({Key? key})
      : super(identificationIntroWidgetModelFactory, key: key);

  @override
  Widget build(IIdentificationIntroWidgetModel wm) {
    return IdentificationLayout(
      showStep: false,
      title: locale.getText('identification_intro_title'),
      subtitle: locale.getText('identification_intro_subtitle'),
      containerTitle: locale.getText('identification_intro_container_title'),
      buttonText: locale.getText('confirm_my_person'),
      onTap: wm.toIdentificationStepOne,
      containerChildren: EntityStateNotifierBuilder<RemoteConfigEntity>(
        listenableEntityState: wm.remoteConfig,
        //TODO: implement loadingBuilder: ,
        //TODO: implement errorBuilder: ,
        builder: (context, data) {
          return Column(
            children: [
              ContainerItem(
                iconName: 'coin',
                title: locale.getText('max_amount_one_payment'),
                subtitle:
                    "${moneyFormat(data?.walletConfirmedMaxAmountToStore)} ${locale.getText('sum')}",
                iconColor: ColorNode.Dark3,
              ),
              SizedBox(
                height: 4,
              ),
              ContainerItem(
                iconName: 'transfer',
                title: locale.getText('max_transfer_amount_between_cards'),
                subtitle:
                    "${moneyFormat(data?.walletConfirmedMaxAmountToTransfer)} ${locale.getText('sum')}",
                iconColor: ColorNode.Dark3,
              ),
            ],
          );
        },
      ),
    );
  }
}
