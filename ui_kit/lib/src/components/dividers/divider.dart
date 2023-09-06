import 'package:flutter/widgets.dart';

import 'package:ui_kit/src/tokens/colors.dart';

class Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration:
          BoxDecoration(border: Border.all(color: IconAndOtherColors.divider)),
    );
  }
}
