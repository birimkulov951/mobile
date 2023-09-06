import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/indentification_sucsess_layout.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/identification_step_one.dart';
import 'package:mobile_ultra/screens/identification/intro/steps/widgets/step_container_item.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';

class IdentificationtryAgainpage extends StatelessWidget {
  static const Tag = '/identification_try_again';

  const IdentificationtryAgainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IdentificationSuccessMessageLayout(
      image: 'assets/graphics_redesign/try_again_message_icon.svg',
      title: locale.getText('identification_failed'),
      subtitle: locale.getText('please_try_again_with_the_following_corrected'),
      buttonText: locale.getText('try_again'),
      buttonText2: locale.getText('go_back_to_the_main_page'),
      currentStep: 3,
      containerChildren: Padding(
        child: Column(
          children: [
            StepContainerItem(
              cicrleColor: Colors.red,
              title: locale.getText('oval_photo_text'),
            ),
            SizedBox(height: 4),
            StepContainerItem(
              cicrleColor: Colors.red,
              title: locale.getText('face_clear'),
            ),
            SizedBox(height: 4),
            StepContainerItem(
              cicrleColor: Colors.red,
              title: locale.getText('monotonous_background'),
            ),
            SizedBox(height: 4),
            StepContainerItem(
              cicrleColor: Colors.red,
              title: locale.getText('camera_clear'),
            ),
            SizedBox(height: 4),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
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
