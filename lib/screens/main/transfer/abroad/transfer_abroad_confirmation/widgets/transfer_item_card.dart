import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';

class TransferItemCard extends StatelessWidget {
  const TransferItemCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageWidget,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget imageWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 40,
          child: imageWidget,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.textRegularSecondary,
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.title5,
              )
            ],
          ),
        )
      ],
    );
  }
}
