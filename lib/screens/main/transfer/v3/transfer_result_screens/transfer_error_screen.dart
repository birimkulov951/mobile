import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class TransferErrorScreen extends StatelessWidget {
  final String headerText;
  final String bodyText;
  final String buttonText;
  final String errorSvgIcon;
  final VoidCallback onPressButton;

  const TransferErrorScreen({
    Key? key,
    required this.headerText,
    required this.bodyText,
    required this.buttonText,
    required this.errorSvgIcon,
    required this.onPressButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorNode.ContainerColor,
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                height: 76,
                width: 76,
                child: SvgPicture.asset(errorSvgIcon),
              ),
              SizedBox(height: 24),
              Text(
                headerText,
                style: TextStyles.title5,
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  bodyText,
                  style: TextStyles.caption1MainSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              ItemContainer(
                backgroundColor: ColorNode.Background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    RoundedButton(
                      onPressed: onPressButton,
                      title: buttonText,
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: _getBottomPadding(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getBottomPadding(BuildContext context) {
    final bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
    return bottomViewPadding == 0 ? 24 : bottomViewPadding;
  }
}
