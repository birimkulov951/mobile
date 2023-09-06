import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

class PriceItem extends StatefulWidget {
  final String title;
  final String price;

  const PriceItem({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  State<PriceItem> createState() => _PriceItemState();
}

class _PriceItemState extends State<PriceItem> {
  @override
  Widget build(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyles.caption1MainSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            widget.price,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyles.textMedium,
          ),
        ],
      );
}
