import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/screens/main/payments/category/communal_payments.dart';
import 'package:mobile_ultra/screens/main/payments/category/connection.dart';
import 'package:mobile_ultra/screens/main/payments/category/foreign_services.dart';
import 'package:mobile_ultra/screens/main/payments/category/internet_and_tv.dart';
import 'package:mobile_ultra/screens/main/payments/category/other_services.dart';
import 'package:mobile_ultra/screens/main/payments/category/transport.dart';
import 'package:mobile_ultra/screens/main/payments/search.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/PaymentType.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/route_utils.dart';

enum Category {
  Connection,
  InternetAndTV,
  Transport,
  CommunalPayments,
  ForeignServices,
  More
}

/// Категории провайдеров
/// arguments:
///     [0] - категория;
///     [1] - Заголовок;
///     [2] - PaymentsType
//todo remove it
class CategoryWidget extends StatefulWidget {
  static const Tag = '/categoryList';

  @override
  State<StatefulWidget> createState() => CategoryWidgetState();
}

class CategoryWidgetState extends BaseInheritedTheme<CategoryWidget> {
  Category? category;
  String? title;
  PaymentType? type;

  @override
  void onThemeChanged() {}

  @override
  Widget get formWidget {
    if (category == null) {
      final List<dynamic>? args = getListArgumentFromContext(context);

      /// TODO Если аргументов не будет
      /// или меньше чем индекс - то будет ошибка
      category = args?[0];
      title = args?[1];
      type = args?[2];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title ?? ''),
        actions: <Widget>[
          SvGraphics.button(
            'search',
            size: 22,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                  context, SearchProvidersWidget.Tag,
                  arguments: [
                    title,
                    type,
                  ]);

              if (result != null) Navigator.pop(context, result);
            },
          ),
        ],
      ),
      body: categoryListView,
    );
  }

  Widget get categoryListView {
    switch (category) {
      case Category.Connection:
        return ConnectionWidget(inject(), type: type);
      case Category.InternetAndTV:
        return InternetAndTVWidget(type: type);
      case Category.CommunalPayments:
        return CommunalPaymentsWidget(inject(), type: type);
      case Category.Transport:
        return TransportWidget(inject(), type: type);
      case Category.ForeignServices:
        return ForeignServicesWidget(type: type);
      default:
        return OtherServicesWidget(
          type: type,
        ); //OtherServicesFactory.createOtherServices(type: type);
    }
  }
}
