import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mobile_ultra/main.dart' show pref, db;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/repositories/merchant_repository.dart';import 'package:mobile_ultra/utils/u.dart';

abstract class MerchantView {
  void onShowLoading();

  void onGetAllData({String error});
}

class MerchantPresenter extends Http with HttpView {
  MerchantPresenter(this.merchantRepository, {this.view})
      : super(path: 'microservice/api/view/all');

  final MerchantView? view;
  final MerchantRepository merchantRepository;

  void getAll() async {
    final lastUpdTime = pref?.configUpdTime;

    if (lastUpdTime == null ||
        lastUpdTime == -1 ||
        !merchantRepository.isPaymentDataLoaded) {
      getData();
    } else {
      final lastDay = DateTime.fromMillisecondsSinceEpoch(lastUpdTime);
      final difference = DateTime.now().difference(lastDay);

      if (difference.inHours >= 1) {
        getData();
      } else {
        view?.onGetAllData();
      }
    }
    view?.onGetAllData();
  }

  void getData({Map<String, dynamic> params = const {'last': '0'}}) {
    view?.onShowLoading();

    makeGet(
      this,
      params: params,
    );
  }

  @override
  void onFail(String error, {String? title, dynamic errorBody}) {
    view?.onGetAllData(error: title ?? error);
  }

  @override
  void onSuccess(body) async {
    await merchantRepository.setAllPaymentData(jsonDecode(body));
    await db?.setAllDataMerchants(jsonDecode(body));
    await pref?.setConfigUpdateTime(DateTime.now().millisecondsSinceEpoch);

    final lastUpdTime = pref?.logoUpdTime;
    if (lastUpdTime != null && lastUpdTime != -1) {
      final lastDay = DateTime.fromMillisecondsSinceEpoch(lastUpdTime);
      final difference = DateTime.now().difference(lastDay);

      printLog(difference.inDays);

      if (difference.inDays > 3) {
        DefaultCacheManager().emptyCache().then((value) =>
            pref?.setLogoUpdateTime(DateTime.now().millisecondsSinceEpoch));
      }
    } else {
      pref?.setLogoUpdateTime(DateTime.now().millisecondsSinceEpoch);
    }

    view?.onGetAllData();
  }
}
