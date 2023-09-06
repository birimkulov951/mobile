import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

/// Class for creating responsive view depending on screen size.
class MainResponsiveWrapper extends StatelessWidget {
  /// Creates a new instance of the [MainResponsiveWrapper].
  const MainResponsiveWrapper({required this.child, super.key});

  /// Widget, which will be wrapped in [ResponsiveWrapper].
  final Widget child;

  @override
  Widget build(final BuildContext context) => ResponsiveWrapper(
        minWidth: 320,
        defaultScale: true,
        mediaQueryData: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        alignment: Alignment.center,
        defaultScaleLandscape: true,
        breakpoints: const <ResponsiveBreakpoint>[
          /// Examples: old Android phones.
          ResponsiveBreakpoint.resize(320, name: PHONE, scaleFactor: 0.8),

          /// Examples: iPhone SE 3
          ResponsiveBreakpoint.resize(
            360,
            name: 'SMALL_MOBILE',
          ),

          /// Examples: iPhone 14 PRO, Xiaomi 12
          ResponsiveBreakpoint.resize(
            390,
            name: MOBILE,
            scaleFactor: 1.05,
          ),

          /// Examples: iPhone 14 PRO MAX
          ResponsiveBreakpoint.resize(
            428,
            name: 'BIG_MOBILE',
            scaleFactor: 1.15,
          ),

          /// Examples: foldable smartphones
          ResponsiveBreakpoint.autoScale(
            520,
            name: 'HUGE_MOBILE',
            scaleFactor: 0.9,
          ),

          /// Examples: iPad mini
          ResponsiveBreakpoint.autoScale(680, name: TABLET, scaleFactor: 1.2),

          /// Examples: iPad Pro (12.9-inch)
          ResponsiveBreakpoint.resize(
            1000,
            name: 'BIG_TABLET',
            scaleFactor: 1.3,
          ),
        ],
        child: child,
      );
}
