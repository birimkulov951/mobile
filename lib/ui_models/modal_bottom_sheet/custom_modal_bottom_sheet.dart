import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  final Widget? child;
  final bool bottom;

  final double maxPercentageHeight;
  final double minPercentageHeight;

  const CustomModalBottomSheet({
    Key? key,
    required this.title,
    this.children,
    this.child,
    this.bottom = true,
    this.maxPercentageHeight = 0.9,
    this.minPercentageHeight = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: bottom,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * maxPercentageHeight,
          minHeight: MediaQuery.of(context).size.height * minPercentageHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Center(
              child: Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  color: ColorNode.Background,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            Visibility(
              visible: title.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextLocale(
                  "$title",
                  style: TextStyles.title4,
                ),
              ),
            ),
            if (child == null) ...(children ?? []),
            if (child != null) Flexible(child: child!),
          ],
        ),
      ),
    );
  }
}
