import 'package:flutter/widgets.dart';

import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

/// Контейнер с декорацией для [ItemTextBlock]
class ItemTextContainer extends StatelessWidget {
  final Widget child;

  const ItemTextContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorNode.Background,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: child,
    );
  }
}

/// Виджет с макетом контента для [ItemTextBlock]
class ItemTextContent extends StatelessWidget {
  final String title;
  final String subTitle;
  final EdgeInsetsGeometry? padding;

  const ItemTextContent({
    Key? key,
    required this.title,
    required this.subTitle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.caption1MainSecondary,
        ),
        SizedBox(height: 4),
        Padding(
          padding: padding ?? EdgeInsets.only(right: 12),
          child: Text(
            subTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.textBold,
          ),
        ),
      ],
    );
  }
}

/// Блок текста
class ItemTextBlock extends StatelessWidget {
  final String title;
  final String subTitle;

  const ItemTextBlock({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemTextContainer(
      child: ItemTextContent(
        title: title,
        subTitle: subTitle,
      ),
    );
  }
}
