
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/circle_image.dart';
import 'package:mobile_ultra/ui_models/various/label_amount.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

const _circleImageSize = 46.0;
const _containerHeight = 70.0;

class TemplateItem extends StatelessWidget {
  final dynamic item;
  final int index;
  final EdgeInsets padding;
  final bool viewControls;
  final bool isLast;
  final TemplateType templateType;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onDeleteItem;

  TemplateItem({
    Key? key,
    required this.item,
    required this.index,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.viewControls = false,
    this.isLast = false,
    this.templateType = TemplateType.Favorite,
    this.onTap,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap?.call(index),
        child: ItemContainer(
          borderRadius: isLast
              ? BorderRadius.vertical(
                  bottom: Radius.circular(24),
                )
              : BorderRadius.zero,
          height: _containerHeight,
          padding: padding,
          child: Row(
            children: [
              Visibility(
                visible: viewControls,
                child: InkWell(
                  key: Key('${WidgetIds.templatesPageDeleteTemplate}_$index'),
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                    ),
                    child: SvgPicture.asset(Assets.addBox),
                  ),
                  onTap: () => onDeleteItem?.call(index),
                ),
              ),
              if (templateType == TemplateType.Favorite ||
                  templateType == TemplateType.Reminder)
                CircleImage(
                  merchantId: templateType == TemplateType.Reminder
                      ? item.merchantId
                      : item.bill!.merchantId,
                  size: _circleImageSize,
                ),
              if (templateType == TemplateType.Transfer)
                Container(
                  width: 46,
                  height: 46,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorNode.accent,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    Assets.transfer,
                    color: ColorNode.ContainerColor,
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Title1(
                            text: templateType == TemplateType.Reminder
                                ? reminderTemplateName(item)
                                : favoriteTemplateName(item),
                            size: 16,
                            weight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        LabelAmount(
                          amount: _getAmount(),
                          fontSize1: 16,
                          fontSize2: 12,
                          fontSize3: 16,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_subtitle() != null)
                          Flexible(
                            child: Title1(
                              text: _subtitle()!,
                              size: 12,
                              color: ColorNode.MainSecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (templateType == TemplateType.Reminder)
                          Title1(
                            text: DateFormat('dd.MM.yyyy').format(
                              DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(item.finishDate, true),
                            ),
                            size: 12,
                            color: ColorNode.MainSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    )
                  ],
                ),
              ),
              Visibility(
                visible: viewControls &&
                    (templateType == TemplateType.Favorite ||
                        templateType == TemplateType.Transfer),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: SvgPicture.asset(Assets.reorder),
                ),
              ),
            ],
          ),
        ),
      );

  double _getAmount() {
    switch (templateType) {
      case TemplateType.None:
        break;
      case TemplateType.Favorite:
        return item.bill.amount;
      case TemplateType.Reminder:
        return item.amount;
      case TemplateType.Transfer:
        return item.bill != null ? item.bill.amount / 100 : 0.0;
    }
    return 0.0;
  }

  String? _subtitle() {
    switch (templateType) {
      case TemplateType.None:
        break;
      case TemplateType.Favorite:
        return item.bill!.account;
      case TemplateType.Reminder:
        return item.account;
      case TemplateType.Transfer:
        return null;
    }
    return null;
  }
}
