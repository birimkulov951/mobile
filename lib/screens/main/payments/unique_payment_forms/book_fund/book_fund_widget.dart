import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile_ultra/extensions/iterable_extension.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/model/payment/pay_params.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/app_bar/custom_app_bar.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/net/payment/book_fund_presenter.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_region.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_school_class.dart';
import 'package:mobile_ultra/net/payment/model/book_fund_sector.dart';
import 'package:mobile_ultra/ui_models/various/book_fund_class_group_selector.dart';
import 'package:mobile_ultra/ui_models/fields/text.dart';
import 'package:mobile_ultra/ui_models/rows/provider_row_item.dart';
import 'package:mobile_ultra/ui_models/various/custom_dropdown_button.dart';
import 'package:mobile_ultra/screens/main/payments/v2/base_payment_page_state.dart';

class BookFundWidget extends StatefulWidget {
  static const Tag = '/bookFundWidget';

  final PaymentParams paymentParams;

  const BookFundWidget({required this.paymentParams});

  @override
  State<StatefulWidget> createState() => BookFundWidgetState();
}

class BookFundWidgetState extends BasePaymentPageState<BookFundWidget> {
  GlobalKey<CustomDropdownButtonState> _regionKey = GlobalKey();
  BookFundRegion? _region;
  List<BookFundRegion> _regions = [];

  GlobalKey<CustomDropdownButtonState> _sectorKey = GlobalKey();
  BookFundSector? _sector;
  List<BookFundSector> _sectors = [];

  GlobalKey<CustomDropdownButtonState> _schoolKey = GlobalKey();
  BookFundSchool? _school;
  List<BookFundSchool> _schools = [];

  GlobalKey<CustomDropdownButtonState> _schoolClassesKey = GlobalKey();
  String? _schoolClassLang;
  BookFundSchoolClass? _schoolClass;
  List<BookFundSchoolClass> _schoolClasses = [];

  GlobalKey<CustomDropdownButtonState> _schoolClassesGroupedKey = GlobalKey();
  List<BookFundSchoolClass> _schoolClassesGrouped = [];

  String? _groupClass;
  String _student = '';

  @override
  void initState() {
    this.paymentParams = widget.paymentParams;

    super.initState();
    isScrolledForm = true;

    if (this.paymentParams?.account != null) _initData4FastPay();
  }

  @override
  String get buttonTitle => locale.getText('continue');

  @override
  bool get enabledFields => true;

  @override
  Widget get formWidget => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PaynetAppBar(
              paymentParams?.title ?? '',
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ItemContainer(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 24,
                    ),
                    child: Column(
                      children: [
                        ProviderItem(
                          merchant: paymentParams?.merchant,
                        ),
                        if (_region != null)
                          CustomDropdownButton<BookFundRegion>(
                            key: _regionKey,
                            title: locale.getText('region'),
                            subTitle: locale.getText('select_region'),
                            value: _region!,
                            items: List.generate(
                              _regions.length,
                              (index) => CustomDropdownItem<BookFundRegion>(
                                label: Text(
                                  _regions[index].regionName ?? '',
                                  style: TextStyles.textInput,
                                ),
                                value: _regions[index],
                                stringValue: _regions[index].regionName ?? '',
                              ),
                            ),
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
                            key: _sectorKey,
                            title: locale.getText('district'),
                            subTitle: locale.getText('select_district'),
                            value: _sector!,
                            items: List.generate(
                                _sectors.length,
                                (index) => CustomDropdownItem<BookFundSector>(
                                      label: Text(
                                        _sectors[index].sectorName ?? '',
                                        style: TextStyles.textInput,
                                      ),
                                      value: _sectors[index],
                                      stringValue:
                                          _sectors[index].sectorName ?? '',
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
                            key: _schoolKey,
                            title: locale.getText('school'),
                            subTitle: locale.getText('select_school'),
                            value: _school!,
                            items: List.generate(
                                _schools.length,
                                (index) => CustomDropdownItem<BookFundSchool>(
                                      label: Text(
                                        _schools[index].schoolNumber ?? '',
                                        style: TextStyles.textInput,
                                      ),
                                      value: _schools[index],
                                      stringValue:
                                          _schools[index].schoolNumber ?? '',
                                    )),
                            onLoadObjects: _getSchools,
                            onChanged: (data) => _school = data,
                          ),
                        if (_schoolClassLang != null)
                          CustomDropdownButton<String>(
                            key: _schoolClassesKey,
                            title: locale.getText('language'),
                            subTitle: locale.getText('choose_language'),
                            value: _schoolClassLang!,
                            items: _schoolClasses
                                .map((e) => e.classLang?.trim() ?? '')
                                .toSet()
                                .map((e) => CustomDropdownItem<String>(
                                      label: Text(
                                        e,
                                        style: TextStyles.textInput,
                                      ),
                                      value: e,
                                      stringValue: e,
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
                            key: _schoolClassesGroupedKey,
                            title: locale.getText('school_clazz'),
                            subTitle: locale.getText('select_school_clazz'),
                            value: _schoolClass!,
                            items: List.generate(
                                _schoolClassesGrouped.length,
                                (index) =>
                                    CustomDropdownItem<BookFundSchoolClass>(
                                      label: Text(
                                        '${_schoolClassesGrouped[index].classNumber} - $_schoolClassLang',
                                        style: TextStyles.textInput,
                                      ),
                                      value: _schoolClassesGrouped[index],
                                      stringValue:
                                          '${_schoolClassesGrouped[index].classNumber} - $_schoolClassLang',
                                    )),
                            onLoadObjects: () {
                              if (_schoolClassLang == null) {
                                onFail(locale.getText('choose_language'));
                                return;
                              }

                              setState(() {
                                _schoolClassesGrouped.addAll(_schoolClasses
                                    .where((element) =>
                                        element.classLang?.trim() ==
                                        _schoolClassLang)
                                    .toList(growable: false));
                              });

                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => _schoolClassesGroupedKey.currentState
                                    ?.showObjectList(),
                              );
                            },
                            onChanged: (data) => _schoolClass = data,
                          ),
                        BookFundClassGroupSelector(
                          value: _groupClass ?? '',
                          onSelect: (group) => _groupClass = group,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 12,
                            right: 16,
                          ),
                          child: CustomTextField(
                            locale.getText('student_fio'),
                            defaultValue: _student,
                            onChanged: (value) => _student = value,
                            action: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                  cardLayout,
                  SizedBox(height: 12),
                  buttonLayout,
                ],
              ),
            ),
          ),
          LoadingWidget(
            showLoading: blockBtn,
          ),
        ],
      );

  void _initData4FastPay() {
    _schoolClassLang = account?.payBill?['class_lang'];
    _student = account?.payBill?['fio'];
    _groupClass = account?.payBill?['class_letter'];

    Future.delayed(const Duration(milliseconds: 250), () {
      onLoad();

      BookFundPresenter.getRegions(
          onGetError: (error) => onLoad(load: false),
          onGetRegions: (result) {
            _regions.addAll(result);
            _region = _regions.firstWhereOrNull((region) =>
                region.regionId == account?.payBill?['school_region']);

            if (_region?.regionId != null)
              BookFundPresenter.getSectors(
                regionId: _region!.regionId!,
                onGetError: (error) => onLoad(load: false),
                onGetSectors: (result) {
                  _sectors.addAll(result);
                  _sector = _sectors.firstWhereOrNull((sector) =>
                      sector.sectorId == account?.payBill?['school_sector']);

                  if (_region?.regionId != null && _sector?.sectorId != null)
                    BookFundPresenter.getSchools(
                      regionId: _region!.regionId!,
                      sectorId: _sector!.sectorId!,
                      onGetError: (error) => onLoad(load: false),
                      onGetSchools: (result) {
                        _schools.addAll(result);
                        _school = _schools.firstWhereOrNull((school) =>
                            school.schoolNumber == account?.payBill?['school']);

                        BookFundPresenter.getSchoolClasses(
                            onGetError: (error) => onLoad(load: false),
                            onGetSchoolClasses: (result) {
                              onLoad(load: false);

                              setState(() {
                                _schoolClasses.addAll(result);

                                _schoolClassesGrouped.addAll(_schoolClasses
                                    .where((schoolClass) =>
                                        schoolClass.classLang?.trim() ==
                                        _schoolClassLang)
                                    .toList(growable: false));

                                _schoolClass = _schoolClassesGrouped
                                    .firstWhereOrNull((schoolClassGroup) =>
                                        schoolClassGroup.classNumber ==
                                        account?.payBill?['class_number']);
                              });
                            });
                      },
                    );
                },
              );
          });
    });
  }

  void _getRegions() {
    onLoad();
    BookFundPresenter.getRegions(
      onGetError: _onError,
      onGetRegions: (result) {
        _regions.addAll(result);

        onLoad(load: false);
        Future.delayed(
          const Duration(milliseconds: 150),
          () => _regionKey.currentState?.showObjectList(),
        );
      },
    );
  }

  void _getSectors() {
    if (_region == null) {
      onFail(locale.getText('select_region'));
      return;
    }

    onLoad();

    if (_region?.regionId != null) {
      BookFundPresenter.getSectors(
        regionId: _region!.regionId!,
        onGetError: _onError,
        onGetSectors: (result) {
          _sectors.addAll(result);

          onLoad(load: false);
          Future.delayed(
            const Duration(milliseconds: 150),
            () => _sectorKey.currentState?.showObjectList(),
          );
        },
      );
    }
  }

  void _getSchools() {
    if (_region == null) {
      onFail(locale.getText('select_region'));
      return;
    }

    if (_sector == null) {
      onFail(locale.getText('select_district'));
      return;
    }

    onLoad();

    if (_region?.regionId != null && _sector?.sectorId != null) {
      BookFundPresenter.getSchools(
        regionId: _region!.regionId!,
        sectorId: _sector!.sectorId!,
        onGetError: _onError,
        onGetSchools: (result) {
          _schools.addAll(result);

          onLoad(load: false);
          Future.delayed(
            const Duration(milliseconds: 150),
            () => _schoolKey.currentState?.showObjectList(),
          );
        },
      );
    }
  }

  void _getSchoolClasses() {
    onLoad();
    BookFundPresenter.getSchoolClasses(
      onGetError: _onError,
      onGetSchoolClasses: (result) {
        _schoolClasses.addAll(result);

        onLoad(load: false);
        Future.delayed(
          const Duration(milliseconds: 150),
          () => _schoolClassesKey.currentState?.showObjectList(),
        );
      },
    );
  }

  void _onError(String error) {
    onLoad(load: false);
    onFail(error);
  }

  @override
  void onAttemptMakePay({int? checkTo}) async {
    jField = JField.Set;

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
    onLoad();

    onFirstMakeCheck(invoice, getRequestJsonData);
  }

  @override
  String get getRequestJsonData {
    super.getRequestJsonData;

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
