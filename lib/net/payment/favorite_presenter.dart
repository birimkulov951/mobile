import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mobile_ultra/main.dart' show db, favoriteList, getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/report/model/transaction.dart';
import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';
import 'package:mobile_ultra/utils/const.dart';

class FavoritePresenter extends Http with HttpView {
  FavoritePresenter(
    String path, {
    this.onGetLastTrans,
    this.onFavoriteSuccess,
    this.onFavoriteDeleted,
    this.onFavoriteFail,
    this.onReorder,
    this.type = GET_FAVORITES,
  }) : super(path: path);

  factory FavoritePresenter.toDelete({
    int? id,
    Function? onDeleted,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'pms2/api/favorites/remove/',
        onFavoriteDeleted: onDeleted,
        onFavoriteFail: onFail,
        type: REMOVE,
      ).._delete(id);

  factory FavoritePresenter.newFavorite({
    dynamic data,
    Function({dynamic data})? onSuccess,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'pms2/api/favorites/save',
        type: NEW_FAVORITE,
        onFavoriteSuccess: onSuccess,
        onFavoriteFail: onFail,
      ).._create(data);

  factory FavoritePresenter.edit({
    dynamic data,
    Function({dynamic data})? onSuccess,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'pms2/api/favorites/edit',
        type: EDIT,
        onFavoriteSuccess: onSuccess,
        onFavoriteFail: onFail,
      ).._edit(data);

  factory FavoritePresenter.lastTrans({
    int? id,
    Function({Transaction data})? onGetLastTrans,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'microservice/api/trans/',
        onGetLastTrans: onGetLastTrans,
        onFavoriteFail: onFail,
        type: GET_LAST_TRANS,
      ).._getLastTrans(id);

  factory FavoritePresenter.favorites({
    Map<String, dynamic>? data,
    Function({dynamic data})? onSuccess,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'pms2/api/favorites/mine',
        onFavoriteFail: onFail,
        onFavoriteSuccess: onSuccess,
      ).._getList(data);

  factory FavoritePresenter.reorderItem({
    required int id,
    required int newOrder,
    VoidCallback? onReorder,
    Function(String error, dynamic errorBody)? onFail,
  }) =>
      FavoritePresenter(
        'pms2/api/favorites/setOrder/',
        type: REORDER,
        onReorder: onReorder,
        onFavoriteFail: onFail,
      ).._reorderItem(id, newOrder);
  static const NEW_FAVORITE = 0;
  static const GET_FAVORITES = 1;
  static const GET_LAST_TRANS = 2;
  static const REMOVE = 3;
  static const EDIT = 4;
  static const REORDER = 5;

  final Function({Transaction data})? onGetLastTrans;
  final Function({dynamic data})? onFavoriteSuccess;
  final Function(String error, dynamic errorBody)? onFavoriteFail;
  final Function? onFavoriteDeleted;
  final VoidCallback? onReorder;

  int type;

  void _getList(Map<String, dynamic>? data) => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        params: data,
      );

  void _delete(int? id) => makeDelete(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        params: ['$id'],
      );

  void _create(dynamic data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: jsonEncode(data),
      );

  void _edit(dynamic data) => makePost(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        data: jsonEncode(data),
      );

  void _getLastTrans(int? id) => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        pathSegments: ['$id'],
      );

  void _reorderItem(int id, int newOrder) => makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        pathSegments: ['$id', '$newOrder'],
      );

  @override
  void onFail(String details, {String? title, errorBody}) =>
      onFavoriteFail?.call(title ?? details, errorBody);

  @override
  void onSuccess(body) {
    switch (type) {
      case GET_FAVORITES:
        db?.removeFavorites().then(
              (value) => db?.saveFavorites(jsonDecode(body)).then((value) {
                if (value.isNotEmpty) {
                  favoriteList.removeWhere(
                    (element) =>
                        element.type == FPIType.MERCHANT ||
                        element.type == FPIType.TRANSFER,
                  );

                  value.forEach((element) {
                    favoriteList.add(element);
                  });

                  favoriteList.sort((a, b) {
                    ///TODO переписать после новой реализации
                    if (a.order == null || b.order == null) {
                      return -1;
                    }
                    return a.order!.compareTo(b.order!);
                  });
                }

                onFavoriteSuccess?.call();
              }),
            );
        break;
      case NEW_FAVORITE:
        db?.saveFavorite(jsonDecode(body)).then((favorite) {
          favoriteList.add(favorite);

          favoriteList.sort((a, b) {
            if (a.order == null || b.order == null) {
              return -1;
            }
            return a.order!.compareTo(b.order!);
          });

          onFavoriteSuccess?.call();
        });
        break;
      case EDIT:
        db?.updateFavorite(jsonDecode(body)).then((favorite) {
          final pos = favoriteList.indexWhere((item) => item.id == favorite.id);
          favoriteList.replaceRange(pos, pos + 1, [favorite]);
          onFavoriteSuccess?.call(data: favorite);
        });
        break;
      case GET_LAST_TRANS:
        onGetLastTrans?.call(
          data: Transaction.fromJson(jsonDecode(body), false),
        );
        break;
      case REMOVE:
        onFavoriteDeleted?.call();
        break;
      case REORDER:
        onReorder?.call();
        break;
    }
  }
}
