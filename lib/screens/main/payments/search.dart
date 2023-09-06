import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/extensions/common_extensions.dart';
import 'package:mobile_ultra/main.dart' show locale, db, appTheme;
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/route_utils.dart';
import 'package:rxdart/rxdart.dart';

//todo remove!

/// Поиск по провайдерам в разрезе категории, т.е. связь, коммунальные и т.д.
/// п.с. возможно будут изменения в завидимости от функционала. Пока что выполнено
/// согласно вёрстки
class SearchProvidersWidget extends StatefulWidget {
  const SearchProvidersWidget(this.merchantRepository, {super.key});

  static const Tag = '/searchProviders';
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => SearchProvidersWidgetState();
}

class SearchProvidersWidgetState
    extends BaseInheritedTheme<SearchProvidersWidget> {
  List<MerchantEntity> items = [];

  String? title;
  PaymentType? type;

  TextEditingController searchController = TextEditingController();
  FocusNode focus = FocusNode();

  PublishSubject<String> searchSubject = PublishSubject<String>();
  late final StreamSubscription searchSub;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () => focus.requestFocus());

    searchSub =
        searchSubject.debounceTime(Duration(milliseconds: 500)).listen(_search);
  }

  @override
  void dispose() {
    searchSubject.close();
    searchSub.cancel();
    super.dispose();
  }

  @override
  void onThemeChanged() {}

  _search(String value) async {
    items = widget.merchantRepository.searchMerchantByName(
      value,
      locale.prefix,
    );
    setState(() {});
  }

  @override
  Widget get formWidget {
    if (type == null) {
      final List<dynamic>? arguments = getListArgumentFromContext(context);
      title = arguments?[0];
      type = arguments?[1];
    }

    return Container(
        color: appTheme.backgroundColor,
        child: SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextField(
                        controller: searchController,
                        focusNode: focus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvGraphics.icon('search'),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        onChanged: (value) async {
                          searchSubject.add(value);
                        },
                      ),
                      IconButton(
                        icon: SvGraphics.icon('close'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  locale.getText('search_result'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -.5,
                  ),
                ),
              ),
              SizedBox(height: 18.5),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, position) => ProviderItem(
                      merchant: items[position],
                      onTap: (value) async {
                        FocusScope.of(context).focusedChild?.unfocus();

                        final result = type == null || title == null
                            ? null
                            : await launchPaymentForm(
                                merchant: value,
                                type: type!,
                                title: title!,
                              );

                        if (result != null) Navigator.pop(context, result);
                      }),
                ),
              ),
            ],
          ),
        )));
  }
}
