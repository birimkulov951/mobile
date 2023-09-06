import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/widgets/transfer_abroad_single_detail_widget.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class TransferAbroadDetailsBottomSheet extends StatelessWidget {
  final String countryIcon;
  final String amountPaid;
  final String commission;
  final Map<String, dynamic> paymentInfo;
  final VoidCallback sharePaymentInfo;

  TransferAbroadDetailsBottomSheet({
    Key? key,
    required this.countryIcon,
    required this.amountPaid,
    required this.commission,
    required this.paymentInfo,
    required this.sharePaymentInfo,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required String countryIcon,
    required String amountPaid,
    required String commission,
    required Map<String, dynamic> paymentInfo,
    required VoidCallback sharePaymentInfo,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: ColorNode.Background,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => TransferAbroadDetailsBottomSheet(
          paymentInfo: paymentInfo,
          sharePaymentInfo: sharePaymentInfo,
          countryIcon: countryIcon,
          amountPaid: amountPaid,
          commission: commission,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: screenHeight - statusBarHeight - 32,
        minHeight: screenHeight / 2,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 6,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              color: ColorNode.ContainerColor,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorNode.GreyScale400,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                Container(
                  height: 46,
                  width: 46,
                  margin: EdgeInsets.only(
                    top: 28,
                    bottom: 24,
                  ),
                  child: SvgPicture.asset(countryIcon),
                ),
                Text(
                  amountPaid,
                  style: TextStyles.title1,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 4,
                    bottom: 12,
                  ),
                  child: Text(
                    commission,
                    style: TextStyles.caption1MainSecondary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: SvgPicture.asset(Assets.success),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      locale.getText('operation_complated'),
                      style: TextStyles.caption1Success,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  16,
                ),
                decoration: BoxDecoration(
                  color: ColorNode.ContainerColor,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.getText('payments_details'),
                          style: TextStyles.headline,
                        ),
                        GestureDetector(
                          onTap: sharePaymentInfo,
                          child: Icon(
                            Platform.isIOS
                                ? Icons.ios_share_rounded
                                : Icons.share,
                            color: ColorNode.iconFill,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    for (final entry in paymentInfo.entries)
                      TransferAbroadSingleDetailWidget(
                        detailName: locale.getText(entry.key),
                        detailValue: entry.value,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
