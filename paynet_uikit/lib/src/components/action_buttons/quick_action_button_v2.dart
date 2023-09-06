import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class QuickActionButtonV2 extends StatelessWidget {
  const QuickActionButtonV2({
    required this.icon,
    required this.text,
    Key? key,
    this.onTap,
  }) : super(key: key);

  QuickActionButtonV2.PlusIcon({required String text})
      : this(
          text: text,
          icon: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ControlColors.accent,
            ),
            child: Center(
              child:
                  ActionIcons.plus.copyWith(color: IconAndOtherColors.constant),
            ),
          ),
        );

  QuickActionButtonV2.TransfersIcon({Key? key, required String text})
      : this(
          key: key,
          text: text,
          icon: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ControlColors.accent,
            ),
            child: Center(
              child: ActionIcons.transfers
                  .copyWith(color: IconAndOtherColors.constant),
            ),
          ),
        );

  final Widget icon;

  final String text;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: QuickActionBox(
        icon: icon,
        bottom: Text(
          text,
          style: Typographies.caption2SemiBold,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}

class QuickActionBox extends StatelessWidget {
  const QuickActionBox({
    required this.icon,
    required this.bottom,
    Key? key,
  }) : super(key: key);

  final Widget icon;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 100,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: icon,
          ),
          const SizedBox(height: 12),
          bottom
        ],
      ),
    );
  }
}

class QuickActionButtonsSliderV2 extends StatelessWidget {
  const QuickActionButtonsSliderV2({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  List<Widget> _getChildren() {
    final List<Widget> list = [];
    final length = children.length;
    for (var i = 0; i < length; i++) {
      final action = children[i];
      list.add(action);
      final isLast = i == length - 1;
      if (!isLast) {
        list.add(
          const SizedBox(
            width: 4,
          ),
        );
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            ..._getChildren(),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
