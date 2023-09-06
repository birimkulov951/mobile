import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class Infobox extends StatelessWidget {
  final String text;
  final String link;
  final Color iconColor;
  final VoidCallback? onTapLink;

  const Infobox({
    Key? key,
    required this.text,
    required this.link,
    required this.iconColor,
    this.onTapLink,
  }) : super(key: key);

  const Infobox.warning({
    Key? key,
    required String text,
  }) : this(
    text: text,
    link: '',
    iconColor: IconAndOtherColors.warning,
  );

  const Infobox.withLink({
    Key? key,
    required String text,
    required VoidCallback onTapLink,
    required String link,
    required Color color,
  }) : this(
    text: text,
    link: link,
    onTapLink: onTapLink,
    iconColor: color,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: BackgroundColors.secondary,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OperationIcons.statusWarning.copyWith(color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: Typographies.caption1,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                  _getLink(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _getLink() {
    if (link.isEmpty) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: onTapLink,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Text(
            link,
            style: Typographies.caption1Link,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
