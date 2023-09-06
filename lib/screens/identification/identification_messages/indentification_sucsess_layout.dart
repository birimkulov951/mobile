import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class IdentificationSuccessMessageLayout extends StatefulWidget {
  final String buttonText;
  final String? buttonText2;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onTap2;
  final int currentStep;
  final Widget? containerChildren;
  final String image;

  const IdentificationSuccessMessageLayout({
    Key? key,
    required this.buttonText,
    this.buttonText2,
    required this.onTap,
    this.onTap2,
    this.containerChildren,
    required this.image,
    required this.title,
    required this.subtitle,
    this.currentStep = 0,
  }) : super(key: key);

  @override
  _IdentificationSuccessMessageLayoutState createState() =>
      _IdentificationSuccessMessageLayoutState();
}

class _IdentificationSuccessMessageLayoutState
    extends BaseInheritedTheme<IdentificationSuccessMessageLayout> {
  Size? screenSize;

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget get formWidget => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          // ios only
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            color: ColorNode.ContainerColor,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 74.0),
                    SvgPicture.asset(
                      widget.image,
                      alignment: Alignment.center,
                      height: 76.0,
                      width: 76.0,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: ColorNode.Dark1,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: ColorNode.MainSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    widget.currentStep == 3
                        ? (widget.containerChildren ?? const SizedBox())
                        : const SizedBox(),
                    if (widget.image.contains('again')) Spacer(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(top: 32.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                      color: ColorNode.Background,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundedButton(
                            bg: ColorNode.Green,
                            title: widget.buttonText,
                            onPressed: widget.onTap,
                            color: ColorNode.ContainerColor,
                          ),
                          widget.currentStep != 0
                              ? widget.buttonText2 == null
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        SizedBox(height: 16),
                                        RoundedButton(
                                          borderSide: BorderSide(
                                            color: ColorNode.MainSecondary,
                                          ),
                                          elevation: 0,
                                          bg: ColorNode.Background,
                                          title: widget.buttonText2!,
                                          onPressed: widget.onTap2,
                                          color: ColorNode.Dark1,
                                        ),
                                      ],
                                    )
                              : const SizedBox(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).viewPadding.bottom +
                                      16)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
