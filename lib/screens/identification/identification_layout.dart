import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/identification/widgets/step_progress_bar.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class IdentificationLayout extends StatefulWidget {
  final int currentStep;
  final bool showStep;
  final String title;
  final String subtitle;
  final String containerTitle;
  final String buttonText;
  final Widget containerChildren;
  final VoidCallback onTap;

  const IdentificationLayout({
    Key? key,
    this.showStep = false,
    this.currentStep = 0,
    required this.title,
    required this.subtitle,
    required this.containerTitle,
    required this.containerChildren,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  _IdentificationLayoutState createState() => _IdentificationLayoutState();
}

class _IdentificationLayoutState
    extends BaseInheritedTheme<IdentificationLayout> {
  late Size screenSize = MediaQuery.of(context).size;

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget get formWidget => Scaffold(
        appBar: AppBar(
          title: TextLocale(
            'confirm_identification',
            style: TextStyles.title5,
          ),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          actions: widget.showStep
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.currentStep} ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ColorNode.Dark1,
                              ),
                            ),
                            TextSpan(
                              text: 'из 2',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorNode.MainSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              : null,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showStep)
              StepProgressBar(
                screenSize: screenSize,
                currentStep: widget.currentStep,
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorNode.Dark1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorNode.MainSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
                color: ColorNode.ContainerColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.containerTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorNode.Dark1,
                    ),
                  ),
                  SizedBox(height: 12),
                  widget.containerChildren,
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.only(
            bottom: Platform.isIOS
                ? MediaQuery.of(context).viewPadding.bottom + 16
                : 16,
            right: 16,
            left: 16,
          ),
          child: RoundedButton(
            bg: ColorNode.Green,
            title: widget.buttonText,
            onPressed: widget.onTap,
            color: ColorNode.ContainerColor,
          ),
        ),
      );
}
