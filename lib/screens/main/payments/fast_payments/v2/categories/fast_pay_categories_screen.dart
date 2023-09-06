import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/fast_pay_categories_screen_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/categories/route/arguments.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/payment/category_item.dart';
import 'package:mobile_ultra/ui_models/payment/subcategory_item.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class FastPayCategoriesScreen
    extends ElementaryWidget<IFastPayCategoriesScreenWidgetModel> {
  final FastPayCategoriesScreenArguments arguments;

  FastPayCategoriesScreen({
    Key? key,
    required this.arguments,
  }) : super(fastPayCategoriesScreenWidgetModelFactory, key: key);

  @override
  Widget build(IFastPayCategoriesScreenWidgetModel wm) {
    return Scaffold(
      appBar: PaynetAppBar(
        locale.getText('select_category'),
        centerTitle: false,
      ),
      body: categoryLayout(wm),
    );
  }

  Widget categoryLayout(IFastPayCategoriesScreenWidgetModel wm) =>
      StateNotifierBuilder(
        listenableState: wm.scrollController,
        builder: (_, __) => SingleChildScrollView(
          controller: wm.scrollController.value!,
          physics: BouncingScrollPhysics(),
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom,
              ),
              child: ItemContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        16,
                        24,
                        12,
                      ),
                      child: Container(
                        height: 44,
                        decoration: const BoxDecoration(
                          color: ColorNode.Main,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimensions.unit1_5),
                          ),
                        ),
                        child: MaterialButton(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimensions.unit1_5),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 13),
                              SvgPicture.asset(Assets.search),
                              SizedBox(width: 9),
                              Text(
                                locale.getText('search'),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: ColorNode.GreyScale400,
                                ),
                              )
                            ],
                          ),
                          onPressed: () => wm.onShowProviders(
                              locale.getText('search'), [], []),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: wm.paymentCategoryList.length,
                      itemBuilder: (context, index) {
                        final item = wm.paymentCategoryList[index];

                        if (item.subCategories.isNotEmpty) {
                          return CategoryItem(
                            icon: SvgPicture.asset(item.icon),
                            categoryIds: item.categoryIds,
                            title: locale.getText(item.title),
                            onExpanded: (isExpanded) {
                              if (isExpanded) {
                                wm.scrollTo(item.subCategories.length);
                              } else {
                                wm.scrollTo(-item.subCategories.length);
                              }
                            },
                            children: [
                              for (final subCategory in item.subCategories)
                                SubcategoryItem(
                                  icon: SvgPicture.asset(subCategory.icon),
                                  categoryId: subCategory.categoryIds,
                                  title: locale.getText(subCategory.title),
                                  onPressed: wm.onShowProviders,
                                ),
                            ],
                          );
                        }

                        return CategoryItem(
                          icon: SvgPicture.asset(item.icon),
                          categoryIds: item.categoryIds,
                          title: locale.getText(item.title),
                          onPressed: wm.onShowProviders,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }),
        ),
      );
}
