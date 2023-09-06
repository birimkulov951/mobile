import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/payment/payment_categories_entity.dart';
import 'package:mobile_ultra/ui_models/payment/category_item.dart';
import 'package:mobile_ultra/ui_models/payment/subcategory_item.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class MerchantCategoryList extends StatelessWidget {
  const MerchantCategoryList({
    required this.paymentCategoriesState,
    required this.scrollTo,
    required this.onShowProviders,
    super.key,
  });

  final ValueNotifier<List<PaymentCategoryEntity>> paymentCategoriesState;
  final void Function(int length) scrollTo;
  final void Function(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  ) onShowProviders;

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (BuildContext context, LocaleHelper locale) {
        return ValueListenableBuilder<List<PaymentCategoryEntity>>(
          valueListenable: paymentCategoriesState,
          builder: (context, state, _) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.length,
              itemBuilder: (context, index) {
                final item = state[index];

                if (item.subCategories.isNotEmpty) {
                  return CategoryItem(
                    key: const Key(WidgetIds.merchantCategoryCategoryList),
                    icon: SvgPicture.asset(item.icon),
                    categoryIds: item.categoryIds,
                    title: locale.getText(item.title),
                    onExpanded: (isExpanded) {
                      if (isExpanded) {
                        scrollTo(item.subCategories.length);
                      } else {
                        scrollTo(-item.subCategories.length);
                      }
                    },
                    children: item.subCategories
                        .map(
                          (e) => SubcategoryItem(
                            key: const Key(WidgetIds.merchantCategorySubcategoryList),
                            icon: SvgPicture.asset(e.icon),
                            categoryId: e.categoryIds,
                            title: locale.getText(e.title),
                            onPressed: onShowProviders,
                          ),
                        )
                        .toList(),
                  );
                }

                return CategoryItem(
                  key: const Key(WidgetIds.merchantCategoryCategoryList),
                  icon: SvgPicture.asset(item.icon),
                  categoryIds: item.categoryIds,
                  title: locale.getText(item.title),
                  onPressed: onShowProviders,
                );
              },
            );
          },
        );
      },
    );
  }
}
