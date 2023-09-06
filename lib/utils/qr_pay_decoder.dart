import 'dart:convert';

import 'package:mobile_ultra/model/payment/qr_pay_params.dart';
import 'package:mobile_ultra/utils/const.dart';

QRPayParams qrPayDecoder(String link) {
  Map<String, dynamic>? jsonService;

  try {
    var decodeResult = jsonDecode(link);
    if (decodeResult is Map<String, dynamic>) jsonService = decodeResult;
  } on Exception catch (_) {}

  if (jsonService != null) {
    var sId = jsonService['s_id'];

    if (sId is String) sId = int.parse(sId);

    switch (sId) {
      case 250:
      case 319:
        // Нотариус
        if ((jsonService['is_notary_service'] ?? 0) == 1) {
          return QRPayParams(
            merchantId: 2669,
            queryParams: 'i=${jsonService['p_acc']}',
          );
        }
        // Загс
        return QRPayParams(
          merchantId: 2669,
          queryParams: 's=13913&i=${jsonService['p_acc']}',
        );
      case 617:
        // Овир, Ид карта
        return QRPayParams(
          merchantId: 2670,
          queryParams: 'i=${jsonService['p_acc']}',
        );
      case 343:
        // Услуги единого окна
        return QRPayParams(
          merchantId: 2672,
          queryParams: 'i=${jsonService['p_acc']}',
        );
      default:
        final Map<dynamic, dynamic>? details = jsonService['details'];

        if (details?.containsKey('order') ?? false) {
          // Суды (Судебные платежи)
          if (RegExp(r'\d{12}').hasMatch(details?['order'])) {
            return QRPayParams(
              merchantId: 3629,
              queryParams: 'i=${details?['order']}',
            );
          }
        }

        if (details?.containsKey('invoice') ?? false) {
          // Государственный кадастр
          if (RegExp(r'^\d{7}-\d{2}\/\d{6}-\d{5}$')
              .hasMatch(details?['invoice'])) {
            return QRPayParams(
              merchantId: 4709,
              queryParams: 'i=${details?['invoice']}',
            );
          }
        }
        break;
    }
  } else {
    QRPayParams qrPayParams = QRPayParams();
    qrPayParams.queryParams = 'i=$link';

    if (link.startsWith(Const.TONIROVKA))
      qrPayParams.merchantId = 3211;
    else if (link.startsWith(Const.DRIVER_DOC))
      qrPayParams.merchantId = 2849;
    else if (Const.GUBDD_PREFIX.contains(link.substring(0, 2)))
      qrPayParams.merchantId = 2629;
    else if (link.startsWith(Const.MIB))
      qrPayParams.merchantId = 4969;
    else if (RegExp(r'^21\d{10}$').hasMatch(link))
      qrPayParams.merchantId = 3629;
    else if (link.length == 11 && int.parse(link.substring(0, 2)) <= 14) {
      qrPayParams.merchantId = 6270;
      qrPayParams.queryParams = 'c=$link';
    }

    return qrPayParams;
  }

  return QRPayParams();
}
