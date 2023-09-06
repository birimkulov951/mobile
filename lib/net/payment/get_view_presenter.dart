import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken, locale;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';

abstract class GetViewPresenterView {
  void onGetView({List<MerchantField> newFields, String error});
}

class GetViewPresenter extends Http with HttpView {
  GetViewPresenterView view;

  GetViewPresenter(this.view) : super(path: 'microservice/api/view/getView');

  void getNewView(dynamic data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: data,
      );

  @override
  void onFail(
    String error, {
    String? title,
    dynamic errorBody,
  }) =>
      view.onGetView(error: title ?? error);

  @override
  void onSuccess(body) {
    List<MerchantField> result = [];

    final Map<String, dynamic> response = jsonDecode(body);
    final List<dynamic> fieldList = response['fields'];

    fieldList.removeWhere((element) => element == null);
    fieldList.sort((a, b) => a['ord'].compareTo(b['ord']));

    fieldList.forEach((field) {
      final List<dynamic> fieldValueList = response['values']
          .where((fieldValue) => fieldValue['field_id'] == field['id'])
          .toList();
      fieldValueList
          .sort((a, b) => a['display_order'].compareTo(b['display_order']));

      result.add(
        MerchantField(
          type: field['type'],
          typeName: field['name'],
          fieldSize: field['fieldSize'],
          label: locale.prefix == LocaleHelper.Russian
              ? field['labelRu']
              : locale.prefix == LocaleHelper.Uzbek
                  ? field['labelUz']
                  : field['labelEn'],
          parentId: '${field['parentId']}',
          controlTypeInfo: field['controlTypeInfo'],
          controlType: field['controlType'],
          readOnly: field['readOnly'],
          defaultValue: field['defaultValue'],
          isRequired: field['requiredField'],
          isHidden: field['hidden'],
          values: List.generate(
            fieldValueList.length,
            (position) {
              return MerchantFieldValue(
                id: fieldValueList[position]['id'],
                label: fieldValueList[position]['field_label_${locale.prefix}'],
                fieldValue: fieldValueList[position]['field_value'],
                amount: fieldValueList[position]['amount'],
                prefix: fieldValueList[position]['prefix'],
                checkId: fieldValueList[position]['check_id'].toString(),
                parentId: fieldValueList[position]['parent_id'],
              );
            },
          ),
        ),
      );
    });

    view.onGetView(newFields: result);
  }
}
