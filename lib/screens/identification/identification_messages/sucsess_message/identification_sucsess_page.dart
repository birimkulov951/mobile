import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/identification/identification_messages/indentification_sucsess_layout.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';

import 'package:mobile_ultra/main.dart';

class IdentificationSuccessPage extends StatelessWidget {
  static const Tag = '/identification_sucsess';

  const IdentificationSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IdentificationSuccessMessageLayout(
      image: "assets/graphics_redesign/success.svg",
      buttonText: locale.getText('ready'),
      title: locale.getText('identification_passed'),
      subtitle: locale.getText("identification_passed_subtitle"),
      onTap: () {
        Navigator.pushReplacementNamed(context, NavigationWidget.Tag);
      },
    );
  }
}
