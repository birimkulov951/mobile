import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

enum BottomSheetType {
  full,
  half,
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key? key,
    this.title,
    this.top,
    this.content,
    this.bottom,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? top,
    Widget? content,
    Widget? bottom,
    WidgetBuilder? builder,
    BottomSheetType type = BottomSheetType.full,
    RouteSettings? routeSettings,
  }) async {
    final queryData = MediaQuery.of(context);
    var height = queryData.size.height;

    switch (type) {
      case BottomSheetType.full:
        final top = queryData.viewPadding.top;
        height -= top;
        height -= 8;
        break;
      case BottomSheetType.half:
        height = height / 2;
        break;
    }

    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: BackgroundColors.modal,
      barrierColor: BackgroundColors.dark,
      constraints: BoxConstraints(minHeight: height, maxHeight: height),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      routeSettings: routeSettings,
      builder: builder ??
          (context) => BottomSheet(
                title: title,
                top: top,
                content: content,
                bottom: bottom,
              ),
    );
  }

  final String? title;

  final Widget? top;

  final Widget? content;

  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Center(
              child: Container(
                height: 4,
                width: 36,
                decoration: const BoxDecoration(
                  color: IconAndOtherColors.divider,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            Visibility(
              visible: title != null,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 12,
                ),
                child: Text(
                  title ?? '',
                  style: Typographies.title4,
                ),
              ),
            ),
            Visibility(
              visible: top != null,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: top ?? const SizedBox(),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return Visibility(
                          visible: content != null,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                            ),
                            child: content ?? const SizedBox(),
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: bottom != null,
          child: Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: bottom ?? const SizedBox(),
            ),
          ),
        )
      ],
    );
  }
}
