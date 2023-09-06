import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/main.dart'
    show db, favoriteList, locale, requestedFavorites;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/net/payment/favorite_presenter.dart';
import 'package:mobile_ultra/net/payment/model/pynetid.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/pay_by_template_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/templates_page.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_route.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget(this.merchantRepository, {this.viewTitle = false});

  final bool viewTitle;
  final MerchantRepository merchantRepository;

  @override
  State<StatefulWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  @override
  void initState() {
    super.initState();

    if (!requestedFavorites) {
      db?.readStoredFavorites().then((items) {
        if (items.isNotEmpty) {
          setState(() => favoriteList.addAll(items));
        }
        _requestFavorites();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (context, locale) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.viewTitle) ...[
              titleLayout,
              SizedBox(height: 16),
            ],
            favoritesLayout,
          ],
        );
      },
    );
  }

  Widget get titleLayout => Visibility(
        visible: widget.viewTitle,
        child: ListTile(
          dense: true,
          title: LocaleBuilder(
            builder: (_, locale) => Text(
              locale.getText('favorite').replaceAll('\n', ' '),
              style: TextStyles.headline,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: favoriteList.length > 4,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: ColorNode.MainIcon,
                    shape: CircleBorder(),
                  ),
                  child: Text(
                    '${favoriteList.length - 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          onTap: _openTemplates,
        ),
      );

  Widget get favoritesLayout => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            ...favoriteList
                .map((e) => FPIWidget(item: e, onTap: _favoritePay))
                .expand((element) => [element, SizedBox(width: 8)])
                .toList(),
            SizedBox(width: 16),
          ],
        ),
      );

  void _openTemplates() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TemplatesPage()),
    );

    setState(() {});
  }

  void _requestFavorites() {
    if (!requestedFavorites) {
      Future.delayed(
        const Duration(milliseconds: 250),
        () => _getFavoriteList(),
      );
    }
  }

  void _getFavoriteList() => FavoritePresenter.favorites(
        data: {
          'page': '0',
          'size': '1000',
        },
        onSuccess: ({data}) => setState(() => requestedFavorites = true),
      );

  Future<void> _favoritePay(FavoriteEntity favorite) async {

    if (favorite.type == FPIType.TRANSFER) {
      await Navigator.pushNamed(
        context,
        TransferTemplateRoute.Tag,
        arguments: TransferTemplateRouteArguments(favorite),
      );

      setState(() {});

      return;
    }

    final merchant =
        widget.merchantRepository.findMerchant(favorite.merchantData?.merchantId);

    if (merchant == null) {
      await showDialog(
        context: context,
        builder: (context) => showMessage(
          context,
          locale.getText('attention'),
          locale.getText('service_not_available'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayByTemplatePage(
          paymentParams: PaymentParams(
            merchant: merchant,
            title: favoriteTemplateName(favorite),
            paymentType: PaymentType.PAY_BY_TEMPLATE,
            account: PynetId(
              account: favorite.merchantData?.account,
              payBill: favorite.merchantData?.params,
            ),
            favorite: favorite,
            templateType: TemplateType.Favorite,
          ),
        ),
      ),
    );
    setState(() {});
  }
}
