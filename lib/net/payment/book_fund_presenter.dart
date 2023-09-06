import 'dart:convert';

import 'package:mobile_ultra/main.dart' show getAccessToken;
import 'package:mobile_ultra/net/http.dart';
import 'package:mobile_ultra/net/http_view.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_region.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school_class.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_sector.dart';
import 'package:mobile_ultra/utils/const.dart';

class BookFundPresenter extends Http with HttpView {
  static const REGIONS = 0;
  static const SECTORS = 1;
  static const SCHOOLS = 2;
  static const SCHOOL_CLASSES = 3;

  int requestType;

  final Function(String)? onGetError;
  final Function(List<BookFundRegion>)? onGetRegions;
  final Function(List<BookFundSector>)? onGetSectors;
  final Function(List<BookFundSchool>)? onGetSchools;
  final Function(List<BookFundSchoolClass>)? onGetSchoolClasses;

  BookFundPresenter(
    String path, {
    this.onGetRegions,
    this.onGetError,
    this.onGetSectors,
    this.onGetSchools,
    this.onGetSchoolClasses,
    this.requestType = REGIONS,
  }) : super(path: path);

  factory BookFundPresenter.getRegions({
    Function(String)? onGetError,
    required Function(List<BookFundRegion>) onGetRegions,
  }) =>
      BookFundPresenter('microservice/api/school/regions',
          onGetError: onGetError, onGetRegions: onGetRegions)
        .._request();

  factory BookFundPresenter.getSectors({
    required String regionId,
    Function(String)? onGetError,
    required Function(List<BookFundSector>) onGetSectors,
  }) =>
      BookFundPresenter(
        'microservice/api/school/sectors/',
        onGetError: onGetError,
        onGetSectors: onGetSectors,
        requestType: SECTORS,
      ).._request(pathSegments: [regionId]);

  factory BookFundPresenter.getSchools({
    required String regionId,
    required String sectorId,
    Function(String)? onGetError,
    required Function(List<BookFundSchool>) onGetSchools,
  }) =>
      BookFundPresenter(
        'microservice/api/school/schools/',
        onGetError: onGetError,
        onGetSchools: onGetSchools,
        requestType: SCHOOLS,
      ).._request(pathSegments: [regionId, sectorId]);

  factory BookFundPresenter.getSchoolClasses({
    Function(String)? onGetError,
    required Function(List<BookFundSchoolClass>) onGetSchoolClasses,
  }) =>
      BookFundPresenter(
        'microservice/api/school/classes',
        onGetError: onGetError,
        onGetSchoolClasses: onGetSchoolClasses,
        requestType: SCHOOL_CLASSES,
      ).._request();

  void _request({
    List<String>? pathSegments,
  }) =>
      makeGet(
        this,
        header: {Const.AUTHORIZATION: getAccessToken()},
        pathSegments: pathSegments,
      );

  @override
  void onFail(String details, {String? title, errorBody}) =>
      onGetError?.call(title ?? details);

  @override
  void onSuccess(body) {
    switch (requestType) {
      case REGIONS:
        onGetRegions?.call(BookFundRegion.parseJsonResponse(jsonDecode(body)));
        break;
      case SECTORS:
        onGetSectors?.call(BookFundSector.parseJsonResponse(jsonDecode(body)));
        break;
      case SCHOOLS:
        onGetSchools?.call(BookFundSchool.parseJsonResponse(jsonDecode(body)));
        break;
      case SCHOOL_CLASSES:
        onGetSchoolClasses
            ?.call(BookFundSchoolClass.parseJsonResponse(jsonDecode(body)));
        break;
    }
  }
}
