import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:mobile_ultra/main.dart' show getAccessToken, pref;
import 'package:mobile_ultra/net/news/model/news.dart';
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/utils/const.dart';

class NewsPresenter extends Http with HttpView {
  final Function(List<News>)? onGetNews;
  final Function(bool)? onCheckNews;

  NewsPresenter(
    String path, {
    this.onGetNews,
    this.onCheckNews,
  }) : super(path: path);

  factory NewsPresenter.getNews(Function(List<News>) onGetNews) =>
      NewsPresenter(
        'uaa/api/account/news',
        onGetNews: onGetNews,
      );

  factory NewsPresenter.checkNews(Function(bool) onCheckNews) {
    return NewsPresenter(
      'microservice/api/news/check',
      onCheckNews: onCheckNews,
    );
  }

  void request() => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
      );

  void requestWithParams() {
    final latestNewsDate = pref?.latestNewsDate;
    makeGet(this, header: {
      Const.AUTHORIZATION: getAccessToken()
    }, params: {
      'date':
          '${DateFormat('dd.MM.yyyy HH:mm:ss').format(latestNewsDate == null || latestNewsDate == -1 ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(latestNewsDate))}'
    });
  }

  @override
  void onFail(String details, {String? title, errorBody}) =>
      onGetNews?.call([]);

  @override
  void onSuccess(body) async {
    if (onGetNews != null) {
      List<dynamic> response = jsonDecode(body);
      final List<News> result = [];

      response.forEach((item) {
        result.add(News.fromJson(item));
      });

      if (result.isNotEmpty && result.first.date != null) {
        pref?.setLatestNewsDate(DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(result.first.date!)
            .millisecondsSinceEpoch);
      }

      onGetNews?.call(result);
    } else
      onCheckNews?.call(body == 'true');
  }
}
