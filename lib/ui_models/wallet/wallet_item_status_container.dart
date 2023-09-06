import 'package:flutter/material.dart';


import 'package:mobile_ultra/ui_models/various/base_item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class WalletItemStatusContainer extends BaseItemContainer {
  final String title;
  final String? subtitle;
  final String status;
  final Color? bgColor;
  final Color? textColor;

  WalletItemStatusContainer({
    required this.title,
    this.subtitle,
    required this.status,
    this.bgColor,
    this.textColor,
  }) : super(height: null, padding: EdgeInsets.zero);

  @override
  Widget get child => ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            selected: true,
            selectedTileColor: bgColor == null ? Colors.transparent : bgColor,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor != null ? textColor : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Visibility(
                      visible: status != '',
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                        decoration: BoxDecoration(
                          color: ColorNode.Dark3,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            subtitle: subtitle == null
                ? const SizedBox.shrink()
                : Text(
                    subtitle!, //max_features
                    style: TextStyle(
                      height: 1.5,
                      color: ColorNode.MainSecondary,
                    ),
                  ),
          ),
        ),
      );
}
