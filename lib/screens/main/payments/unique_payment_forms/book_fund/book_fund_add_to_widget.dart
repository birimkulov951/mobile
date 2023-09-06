import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale, appTheme;
import 'package:mobile_ultra/net/payment/book_fund_presenter.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_region.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school_class.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_sector.dart';
import 'package:mobile_ultra/screens/base/base_autopayment_form.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/book_fund_class_group_selector.dart';
import 'package:mobile_ultra/ui_models/various/custom_dropdown_button.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';

import 'package:mobile_ultra/ui_models/buttons/next_button.dart';

/// Создание/Редактирование автоплатежа
/// arguments:
///     Required[0] - action: create/edit;
///     Required[1] - merchant;
///     Required[2] - reminder or null

class BookFundAddToWidget extends StatefulWidget {
  static const Tag = '/bookFundAddToWidget';

  @override
  State<StatefulWidget> createState() => BookFundAddToWidgetState();
}

class BookFundAddToWidgetState
    extends BaseAutopaymentForm<BookFundAddToWidget> {
  BookFundRegion? _region;
  List<BookFundRegion> _regions = [];

  BookFundSector? _sector;
  List<BookFundSector> _sectors = [];

  BookFundSchool? _school;
  List<BookFundSchool> _schools = [];

  String? _schoolClassLang;
  BookFundSchoolClass? _schoolClass;
  List<BookFundSchoolClass> _schoolClasses = [];
  List<BookFundSchoolClass> _schoolClassesGrouped = [];

  String? _groupClass;
  String _student = '';

  @override
  Widget get getUI => Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title ?? ''),
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProviderItem(merchant: merchant),
                  SizedBox(height: 8),
                  if (_region != null)
                    CustomDropdownButton<BookFundRegion>(
                      title: locale.getText('region'),
                      subTitle: locale.getText('select_region'),
                      value: _region!,
                      items: List.generate(
                          _regions.length,
                          (index) => CustomDropdownItem<BookFundRegion>(
                                label: Text(
                                  _regions[index].regionName ?? '',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                value: _regions[index],
                              )),
                      onLoadObjects: _getRegions,
                      onChanged: (data) => setState(() {
                        _region = data;

                        _sector = null;
                        _sectors.clear();

                        _school = null;
                        _schools.clear();
                      }),
                    ),
                  if (_sector != null)
                    CustomDropdownButton<BookFundSector>(
                      title: locale.getText('district'),
                      subTitle: locale.getText('select_district'),
                      value: _sector!,
                      items: List.generate(
                          _sectors.length,
                          (index) => CustomDropdownItem<BookFundSector>(
                                label: Text(
                                  _sectors[index].sectorName ?? '',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                value: _sectors[index],
                              )),
                      onLoadObjects: _getSectors,
                      onChanged: (data) => setState(() {
                        _sector = data;

                        _school = null;
                        _schools.clear();
                      }),
                    ),
                  if (_school != null)
                    CustomDropdownButton<BookFundSchool>(
                      title: locale.getText('school'),
                      subTitle: locale.getText('select_school'),
                      value: _school!,
                      items: List.generate(
                          _schools.length,
                          (index) => CustomDropdownItem<BookFundSchool>(
                                label: Text(
                                  _schools[index].schoolNumber ?? '',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                value: _schools[index],
                              )),
                      onLoadObjects: _getSchools,
                      onChanged: (data) => _school = data,
                    ),
                  if (_schoolClassLang != null)
                    CustomDropdownButton<String>(
                      title: locale.getText('language'),
                      subTitle: locale.getText('choose_language'),
                      value: _schoolClassLang!,
                      items: _schoolClasses
                          .map((e) => e.classLang?.trim())
                          .toSet()
                          .map((e) => CustomDropdownItem<String>(
                                label: Text(
                                  e ?? '',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                value: e ?? '',
                              ))
                          .toList(growable: false),
                      onLoadObjects: _getSchoolClasses,
                      onChanged: (data) => setState(() {
                        _schoolClassLang = data;
                        _schoolClassesGrouped.clear();
                      }),
                    ),
                  if (_schoolClass != null)
                    CustomDropdownButton<BookFundSchoolClass>(
                      title: locale.getText('school_clazz'),
                      subTitle: locale.getText('select_school_clazz'),
                      value: _schoolClass!,
                      items: List.generate(
                          _schoolClassesGrouped.length,
                          (index) => CustomDropdownItem<BookFundSchoolClass>(
                                label: Text(
                                  '${_schoolClassesGrouped[index].classNumber} - $_schoolClassLang',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                value: _schoolClassesGrouped[index],
                              )),
                      onLoadObjects: () => setState(() {
                        if (_schoolClassLang == null) {
                          onFail(locale.getText('choose_language'));
                          return;
                        }

                        _schoolClassesGrouped.addAll(_schoolClasses
                            .where((element) =>
                                element.classLang?.trim() == _schoolClassLang)
                            .toList(growable: false));
                      }),
                      onChanged: (data) => _schoolClass = data,
                    ),
                  if (_groupClass != null)
                    BookFundClassGroupSelector(
                      value: _groupClass!,
                      onSelect: (group) => _groupClass = group,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: CustomTextField(
                      locale.getText('student_fio'),
                      defaultValue: _student,
                      onChanged: (value) => _student = value,
                      action: TextInputAction.done,
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 10, right: 16),
                        child: CustomTextField(
                          locale.getText('name'),
                          key: keyName,
                          action: TextInputAction.done,
                        ),
                      ),
                      Visibility(
                          visible: Platform.isIOS,
                          child: NextButton(
                            onPress: _attemptPay,
                            bottom: 5,
                            right: 14,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (btnTitle != null)
            Visibility(
              visible: Platform.isAndroid,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RoundedButton(
                    margin: const EdgeInsets.all(16),
                    title: btnTitle!,
                    bg: appTheme.textTheme.bodyText2?.color,
                    color: appTheme.backgroundColor,
                    onPressed: _attemptPay),
              ),
            ),
          LoadingWidget(showLoading: showLoading),
        ],
      );

  void _getRegions() => BookFundPresenter.getRegions(
        onGetError: onFail,
        onGetRegions: (result) => setState(() => _regions.addAll(result)),
      );

  void _getSectors() {
    if (_region == null) {
      setState(() => onFail(locale.getText('select_region')));
      return;
    }

    if (_region?.regionId != null) {
      BookFundPresenter.getSectors(
        regionId: _region!.regionId!,
        onGetError: onFail,
        onGetSectors: (result) => setState(() => _sectors.addAll(result)),
      );
    }
  }

  void _getSchools() {
    if (_region == null) {
      setState(() => onFail(locale.getText('select_region')));
      return;
    }

    if (_sector == null) {
      setState(() => onFail(locale.getText('select_district')));
      return;
    }
    final regionId = _region!.regionId;
    final sectorId = _sector!.sectorId;

    if (regionId == null || sectorId == null)
      BookFundPresenter.getSchools(
        regionId: regionId!,
        sectorId: sectorId!,
        onGetError: onFail,
        onGetSchools: (result) => setState(() => _schools.addAll(result)),
      );
  }

  void _getSchoolClasses() => BookFundPresenter.getSchoolClasses(
        onGetError: onFail,
        onGetSchoolClasses: (result) =>
            setState(() => _schoolClasses.addAll(result)),
      );

  void _attemptPay({int? checkTo}) async {
    if (_region == null) {
      onFail(locale.getText('select_region'));
      return;
    }

    if (_sector == null) {
      onFail(locale.getText('select_district'));
      return;
    }

    if (_school == null) {
      onFail(locale.getText('select_school'));
      return;
    }

    if (_schoolClassLang == null) {
      onFail(locale.getText('choose_language'));
      return;
    }

    if (_schoolClass == null) {
      onFail(locale.getText('select_school_clazz'));
      return;
    }

    if (_groupClass == null) {
      onFail(locale.getText('select_clazz_group'));
      return;
    }

    if (_student.isEmpty) {
      onFail(locale.getText('input_student_fio'));
      return;
    }

    FocusScope.of(context).focusedChild?.unfocus();

    setState(() => blockBtn = true);
    onShowLoading(locale.getText('processing_data'));

    onFirstMakeCheck(invoice, await getRequestData);
  }

  @override
  Future<String> get getRequestData async {
    await super.getRequestData;

    requestBody['amount'] = _schoolClass?.amountWithCommission;
    requestBody['account'] = _school?.schoolAccount;

    requestBody['params'] = {
      "pay_account": _school?.schoolAccount,
      "pay_amount": _schoolClass?.amount,
      "amount": _schoolClass?.amountWithCommission,
      "fio": _student,
      "school": _school?.schoolNumber,
      "class_lang": _schoolClass?.classLang,
      "class_number": _schoolClass?.classNumber,
      "class_letter": _groupClass,
      "school_region": _region?.regionId,
      "school_region_name": _region?.regionName,
      "school_sector": _sector?.sectorId,
      "school_sector_name": _sector?.sectorName,
    };

    return jsonEncode(requestBody);
  }
}
