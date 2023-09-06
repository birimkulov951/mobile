import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';

class TransferAbroadSingleDetailWidget extends StatelessWidget {
  final String detailName;
  final String detailValue;

  const TransferAbroadSingleDetailWidget({
    Key? key,
    required this.detailName,
    required this.detailValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            detailName,
            style: TextStyles.caption1MainSecondary,
          ),
          Text(
            detailValue,
            style: TextStyles.textRegular,
          ),
        ],
      ),
    );
  }
}
