import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/providers/providers.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/payment/category_item.dart';
import 'package:mobile_ultra/ui_models/payment/subcategory_item.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class CategoryAndProvidersWidget extends StatefulWidget {
  const CategoryAndProvidersWidget(this.merchantRepository, {super.key});

  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => _CategoryAndProvidersWidgetState();
}

class _CategoryAndProvidersWidgetState
    extends BaseInheritedTheme<CategoryAndProvidersWidget> {
  final _scrollCtrl = ScrollController();

  final _paymentCatList = Const.paymentCatList;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget get formWidget => Scaffold(
        appBar: AppBar(
          title: TextLocale('select_category'),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        body: categoryLayout,
      );

  Widget get categoryLayout => SingleChildScrollView(
        controller: _scrollCtrl,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: ItemContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.unit3,
                      Dimensions.unit2, Dimensions.unit3, Dimensions.unit1_5),
                  child: Container(
                    height: 44,
                    decoration: const BoxDecoration(
                      color: ColorNode.Main,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.unit1_5),
                      ),
                    ),
                    child: MaterialButton(
                      key: const Key(WidgetIds.categoryAndProvidersSearch),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.unit1_5),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 13),
                          SvgPicture.asset(
                              'assets/graphics_redesign/search.svg'),
                          const SizedBox(width: 9),
                          Text(
                            locale.getText('search'),
                            style: TextStyle(
                                fontSize: 18, color: ColorNode.GreyScale400),
                          )
                        ],
                      ),
                      onPressed: () =>
                          onShowProviders(locale.getText('search'), [], []),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _paymentCatList.length,
                    itemBuilder: (context, index) {
                      final item = _paymentCatList[index];

                      if (item.subCategories.isNotEmpty) {
                        return CategoryItem(
                          key: Key(
                              '${WidgetIds.categoryAndProvidersCategoryList}_$index'),
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
                          children: [
                            for (int i = 0; i < item.subCategories.length; i++)
                              SubcategoryItem(
                                key: Key(
                                    '${WidgetIds.categoryAndProvidersSubcategoryList}_$i'),
                                icon: SvgPicture.asset(
                                    item.subCategories[i].icon),
                                categoryId: item.subCategories[i].categoryIds,
                                title:
                                    locale.getText(item.subCategories[i].title),
                                onPressed: onShowProviders,
                              ),
                          ],
                        );
                      }

                      return CategoryItem(
                        key: Key(
                            '${WidgetIds.categoryAndProvidersCategoryList}_$index'),
                        icon: SvgPicture.asset(item.icon),
                        categoryIds: item.categoryIds,
                        title: locale.getText(item.title),
                        onPressed: onShowProviders,
                      );
                    }),
                const SizedBox(height: Dimensions.unit2)
              ],
            ),
          ),
        ),
      );

  void onShowProviders(
    String title,
    List<int> categoryId,
    List<int> excludeId,
  ) async {
    if (categoryId.isNotEmpty && categoryId.first < 0) {
      final merchant =
          widget.merchantRepository.findMerchant(categoryId.first * -1);

      Navigator.pop(
        context,
        merchant == null
            ? null
            : PaymentParams(
                title: title,
                merchant: merchant,
                paymentType: PaymentType.NEW_TEMPLATE,
              ),
      );
      return;
    }

    final result = await viewModalSheet<PaymentParams>(
      context: context,
      child: ProvidersWidget(
        title: title,
        categoryId: categoryId,
        excludeId: excludeId,
        paymentType: PaymentType.NEW_TEMPLATE,
        merchantRepository: widget.merchantRepository,
      ),
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  void scrollTo(int itemsCount) {
    _scrollCtrl.animateTo(_scrollCtrl.offset + (itemsCount * 56),
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
