import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/ui_models/rows/contact_row_item.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:utils/module/contact.dart';
import 'package:utils/utils.dart';

const _uzbekPhoneNumberCountryCode = '+998';

class ContactSelector extends StatefulWidget {
  final String? prefix;

  ContactSelector({
    this.prefix,
  });

  @override
  State<ContactSelector> createState() => _ContactSelectorState();
}

class _ContactSelectorState extends State<ContactSelector> {
  late TextEditingController _searchController;
  late List<Contact> _contactList;
  late List<Contact> _sortedContactList;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _contactList = [];
    _sortedContactList = [];
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final allContactList = await Utils.getContactList();

      _contactList = widget.prefix == null
          ? allContactList
          : allContactList
              .where((contact) =>
                  contact.phone.substring(4, 6) == widget.prefix ||
                  contact.phone.startsWith(widget.prefix!))
              .toList();
      _sortedContactList = _contactList;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 12,
            ),
            child: TextLocale(
              'select_contact',
              style: TextStyles.title4,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: _searchController,
                style: TextStyles.textInput,
                decoration: InputDecoration(
                  hintText: locale.getText('search'),
                  hintStyle: TextStyles.textInputMainSecondary,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(Assets.search),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: SvgPicture.asset(
                              Assets.searchClear,
                            ),
                          ),
                          onTap: _onClear,
                        )
                      : SizedBox(),
                ),
                onChanged: _onSearch,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: _sortedContactList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16.0),
              itemBuilder: (_, index) => ContactRowItem(
                contact: _sortedContactList.elementAt(index),
                onSelectPhone: _onSelectPhone,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      );

  void _onClear() => setState(() {
        _searchController.clear();
        _sortedContactList = _contactList;
      });

  void _onSearch(String searchText) => setState(() {
        if (searchText.isEmpty) {
          _sortedContactList = _contactList;
        } else {
          _sortedContactList = _contactList
              .where((contact) =>
                  contact.name
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ||
                  contact.phone.contains(searchText))
              .toList();
        }
      });

  void _onSelectPhone(String phoneNumber) {
    String resultPhoneNumber;

    if (phoneNumber.startsWith(_uzbekPhoneNumberCountryCode)) {
      resultPhoneNumber =
          phoneNumber.substring(_uzbekPhoneNumberCountryCode.length);
    } else if (phoneNumber.startsWith('0')) {
      resultPhoneNumber = phoneNumber.substring(1);
    } else {
      resultPhoneNumber = phoneNumber;
    }

    Navigator.pop(context, resultPhoneNumber);
  }
}
