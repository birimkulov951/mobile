import 'dart:convert';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/history/modal/filter_date.dart';
import 'package:mobile_ultra/net/history/modal/history.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

enum HistoryType {
  history,
  debidSum,
}

abstract class HistoryView {
  void onHistory({
    required bool isLoading,
    List<HistoryResponse>? history,
    String? error,
    dynamic errorBody,
  });
}

class HistoryPresenter extends Http with HttpView {
  final HistoryView view;
  final HistoryType type;

  HistoryPresenter(
    String path, {
    required this.view,
    required this.type,
  }) : super(path: path);

  factory HistoryPresenter.debidSum(HistoryView view) => HistoryPresenter(
        'microservice/api/trans/sum',
        view: view,
        type: HistoryType.debidSum,
      );

  factory HistoryPresenter.history(HistoryView view, String query) =>
      HistoryPresenter(
        'microservice/api/trans/all/cards?$query',
        view: view,
        type: HistoryType.history,
      );

  void postHistory({required PeriodDateType cardData}) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: jsonEncode(<String, dynamic>{
          "lang": locale.prefix.toUpperCase(),
          "cardData": cardData.cardData,
        }),
      );

  @override
  void onFail(
    String error, {
    String? title,
    dynamic errorBody,
  }) {
    if (type == HistoryType.history) {
      view.onHistory(
        error: title ?? error,
        errorBody: errorBody,
        isLoading: false,
      );
    }
  }

  @override
  void onSuccess(dynamic body) {
    if (type == HistoryType.history) {
      final Iterable l = json.decode(body);
      final List<HistoryResponse> posts = [];
      for (final e in l) {
        posts.add(HistoryResponse.fromJson(e));
      }
      view.onHistory(history: posts, isLoading: false);
    }
  }
}
