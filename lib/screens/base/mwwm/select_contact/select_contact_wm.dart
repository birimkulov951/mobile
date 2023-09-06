import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

import 'package:mobile_ultra/screens/base/mwwm/select_contact/select_contact_bottom_sheet.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_contact/select_contact_model.dart';

abstract class ISelectContactWidgetModel extends IWidgetModel {
  abstract final StateNotifier<List<PhoneContactEntity>> contactsState;

  abstract final TextEditingController searchController;

  void onSelectContact(PhoneContactEntity contact);

  String formatPhoneNumber(String phoneNUmber);
}

class SelectContactWidgetModel
    extends WidgetModel<SelectContactBottomSheet, SelectContactModel>
    with SystemWidgetModelMixin<SelectContactBottomSheet, SelectContactModel>
    implements ISelectContactWidgetModel {
  SelectContactWidgetModel(super.model);

  @override
  final TextEditingController searchController = TextEditingController();

  @override
  final StateNotifier<List<PhoneContactEntity>> contactsState =
      StateNotifier<List<PhoneContactEntity>>();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    final route = ModalRoute.of(context);
    route?.animation?.addStatusListener(_routeAnimationListener);
    searchController.addListener(_searchContacts);
  }

  @override
  void dispose() {
    searchController.dispose();
    contactsState.dispose();
    final route = ModalRoute.of(context);
    route?.animation?.removeStatusListener(_routeAnimationListener);
    super.dispose();
  }

  @override
  void onSelectContact(PhoneContactEntity contact) {
    Navigator.of(context).pop(contact);
  }

  @override
  String formatPhoneNumber(String phoneNUmber) {
    return uikit.formatPhoneNumber(phoneNUmber);
  }

  _routeAnimationListener(status) {
    if (status == AnimationStatus.completed) {
      _searchContacts();
      final route = ModalRoute.of(context);
      route?.animation?.removeStatusListener(_routeAnimationListener);
    }
  }

  void _searchContacts() async {
    final contacts = await findContacts(searchText: searchController.text);
    contactsState.accept(contacts);
  }
}

SelectContactWidgetModel wmFactory(context) => SelectContactWidgetModel(
      SelectContactModel(
        systemRepository: inject(),
      ),
    );
