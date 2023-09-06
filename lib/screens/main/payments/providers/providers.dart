import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/interactor/analytics/data/payment_opened_data.dart';
import 'package:mobile_ultra/main.dart' show db, locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_result/payment_result.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:rxdart/rxdart.dart';

/// Фрагмент со списком поставщиков услуг в разрезе категории.
/// arguments:
///     [0] - Title;
///     [1] - Category id;
///     [2] - payment type

class ProvidersWidget extends StatefulWidget {
  const ProvidersWidget({
    required this.merchantRepository,
    this.title = '',
    this.categoryId = const [],
    this.excludeId = const [],
    this.paymentType = PaymentType.MAKE_PAY,
    this.isFastPay = false,
  });

  static const Tag = '/providers';

  final String title;
  final List<int> categoryId;
  final List<int> excludeId;
  final PaymentType paymentType;
  final bool isFastPay;
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => ProvidersWidgetState();
}

class ProvidersWidgetState extends BaseInheritedTheme<ProvidersWidget> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  PublishSubject<String> searchSubject = PublishSubject<String>();
  late final StreamSubscription searchSub;

  List<MerchantEntity> _items = [];
  List<MerchantEntity> _sortedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.categoryId.isEmpty && widget.excludeId.isEmpty) {
      _searchFocus.requestFocus();
    }
    Future.delayed(const Duration(milliseconds: 250), () => getMerchants());

    searchSub =
        searchSubject.debounceTime(Duration(milliseconds: 500)).listen(_search);
  }

  @override
  void dispose() {
    _items.clear();
    _sortedItems.clear();

    _searchController.dispose();
    _searchFocus.dispose();

    searchSubject.close();
    searchSub.cancel();
    super.dispose();
  }

  void _unfocus() {
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus?.hasFocus ?? false) {
      primaryFocus?.unfocus();
    }
  }

  @override
  Widget get formWidget => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _unfocus,
        child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _unfocus();
              }
              return true;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: TextLocale(
                    widget.title,
                    style: TextStyles.title4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            key: const Key(WidgetIds.categoryAndProvidersSearchInput),
                            controller: _searchController,
                            focusNode: _searchFocus,
                            style: TextStyles.textInput,
                            decoration: InputDecoration(
                              hintText: locale.getText('search'),
                              hintStyle: TextStyles.textInputMainSecondary,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(Assets.search),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: SvgPicture.asset(
                                          Assets.searchClear,
                                        ),
                                      ),
                                      onTap: onClear,
                                    )
                                  : SizedBox(),
                            ),
                            onChanged: onSearch,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _searchFocus.hasFocus,
                        child: AnimatedOpacity(
                          opacity: _searchFocus.hasFocus ? 1 : 0,
                          duration: const Duration(milliseconds: 1500),
                          child: GestureDetector(
                            key: const Key(WidgetIds.categoryAndProvidersCancel),
                            onTap: () {
                              _searchFocus.unfocus();
                              onCancelSearch();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: TextLocale(
                                'cancellation',
                                style: TextStyles.caption1,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: _sortedItems.isNotEmpty
                        ? ListView.builder(
                            primary: false,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _sortedItems.length,
                            itemBuilder: (_, position) => ProviderItem(
                              key: Key('${WidgetIds.categoryAndProvidersMerchantList}_$position'),
                              merchant: _sortedItems[position],
                              subtitle: widget.title,
                              onTap: providerItemTap,
                            ),
                          )
                        : SizedBox()),
              ],
            )),
      );

  void getMerchants() {
    List<MerchantEntity> merchants = [];
    if (widget.categoryId.isNotEmpty) {
      merchants = widget.merchantRepository.getMerchantList2(widget.categoryId);
      onGetMerchants(merchants);
    } else if (widget.excludeId.isNotEmpty) {
      merchants =
          widget.merchantRepository.getOtherMerchantList(widget.excludeId);
      onGetMerchants(merchants);
    }
  }

  void onGetMerchants(List<MerchantEntity> items) => setState(() {
        if (_items.isEmpty) {
          _items.addAll(items);
        }
        _sortedItems.addAll(items);
      });

  void onClear() {
    setState(() {
      _searchController.clear();
    });
    _sortedItems.clear();
    getMerchants();
  }

  void onCancelSearch() {
    _searchFocus.unfocus();
    Navigator.pop(context);
  }

  void onSearch(String value) {
    searchSubject.add(value);
  }

  void _search(String searchText) {
    List<MerchantEntity> merchants = [];
    _sortedItems.clear();
    if (widget.excludeId.isEmpty && widget.categoryId.isEmpty) {
      merchants = widget.merchantRepository
          .searchMerchantByName(searchText, locale.prefix);
      _sortedItems.addAll(merchants);
    } else {
      merchants = widget.merchantRepository
          .searchMerchantByName(searchText, locale.prefix);

      for (final MerchantEntity merchant in merchants) {
        if (widget.categoryId.contains(merchant.categoryId)) {
          _sortedItems.add(merchant);
        }
      }
    }
    setState(() {});
  }

  String getCategoryTitle(MerchantEntity? merchant) {
    try {
      final category = Const.paymentCatList.firstWhere(
          (element) => element.categoryIds.contains(merchant!.categoryId));
      return locale.getText(category.title);
    } on Object catch (e) {
      printLog(e.toString());
    }
    return '';
  }

  void providerItemTap(MerchantEntity? merchant) async {
    FocusScope.of(context).focusedChild?.unfocus();

    if (widget.paymentType != PaymentType.MAKE_PAY) {
      Navigator.pop(
        context,
        PaymentParams(
          title: getCategoryTitle(merchant),
          merchant: merchant,
          paymentType: PaymentType.NEW_TEMPLATE,
        ),
      );
      return;
    }

    final result = await launchPaymentPage(
      paymentParams: PaymentParams(
        title: getCategoryTitle(merchant),
        merchant: merchant,
        paymentType: widget.paymentType,
        paymentOpenedSource: PaymentOpenedSource.categories,
        isFastPay: widget.isFastPay,
      ),
    );

    if (result == PaymentResultAction.Close) {
      Navigator.pop(context, result);
    }
  }
}
