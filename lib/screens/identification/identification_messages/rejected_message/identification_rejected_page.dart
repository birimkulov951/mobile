import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/indentification_sucsess_layout.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';

class IdentificationRejectedPage extends StatelessWidget {
  static const Tag = '/identification_rejected';

  const IdentificationRejectedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IdentificationSuccessMessageLayout(
      image: 'assets/graphics_redesign/fail.svg',
      title: locale.getText('service_is_temporarily_unavailable'),
      subtitle: locale.getText('write_to_us_in_support'),
      buttonText: locale.getText('try_again'),
      buttonText2: locale.getText('go_back_to_the_main_page'),
      currentStep: 2,
      onTap: () {
        // Navigator.pushReplacementNamed(context, IdentificationStepOne.Tag);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => IdentificationStepOne()),
            (Route<dynamic> route) => false);
      },
      onTap2: () {
        Navigator.pushReplacementNamed(context, NavigationWidget.Tag);
      },
    );
  }
}
