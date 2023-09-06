import 'package:elementary/elementary.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/domain/phone_contact/phone_contact_entity.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:ui_kit/ui_kit.dart' as uikit;

import 'package:mobile_ultra/screens/base/mwwm/select_contact/select_contact_wm.dart';

class SelectContactBottomSheet
    extends ElementaryWidget<ISelectContactWidgetModel> {
  SelectContactBottomSheet() : super(wmFactory);

  static Future<PhoneContactEntity?> show(BuildContext context) async {
    return await uikit.BottomSheet.show(
        context: context,
        builder: (context) {
          return SelectContactBottomSheet();
        });
  }

  @override
  Widget build(ISelectContactWidgetModel wm) {
    return LocaleBuilder(
      builder: (context, locale) {
        return uikit.BottomSheet(
          title: locale.getText('contacts'),
          top: uikit.SearchInputV2(
            controller: wm.searchController,
            focusNode: FocusNode(),
            hintText: locale.getText('enter_name'),
          ),
          content: StateNotifierBuilder<List<PhoneContactEntity>>(
            listenableState: wm.contactsState,
            builder: (context, state) {
              state = state ?? [];
              if (state.isEmpty && wm.searchController.text.isNotEmpty) {
                return Center(
                  child: Text(
                    locale.getText('contact_not_found'),
                    style: uikit.Typographies.caption1,
                  ),
                );
              }
              return Column(
                children: state
                    .map(
                      (contact) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => wm.onSelectContact(contact),
                        child: uikit.TitleDescriptionCell.Chevron(
                          icon: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: uikit.ControlColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: uikit.ActionIcons.phoneAlt.copyWith(
                                color: uikit.IconAndOtherColors.constant),
                          ),
                          title: contact.name,
                          description: wm.formatPhoneNumber(contact.phone),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }
}
