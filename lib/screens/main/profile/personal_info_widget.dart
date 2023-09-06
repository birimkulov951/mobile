import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale, pref;
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonalInfoWidget extends StatelessWidget {
  const PersonalInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
      mask: '+### ## ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Title1(
          text: 'personal_data',
          size: 22,
          weight: FontWeight.w700,
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
        ),
        Title1(
          text: 'personal_info_edit_hint',
          size: 16,
          weight: FontWeight.w400,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: pref?.fullName),
                enabled: false,
                decoration: InputDecoration(
                  labelText: locale.getText('fio'),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              TextField(
                controller: TextEditingController(text: pref?.userDocument),
                enabled: false,
                decoration: InputDecoration(
                  labelText: locale.getText('doc_num'),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              TextField(
                controller: TextEditingController(
                    text:
                        '${maskFormatter.maskText(pref?.getViewLogin ?? '')}'),
                enabled: false,
                decoration: InputDecoration(
                    labelText: locale.getText('phone_num'),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
              TextField(
                controller: TextEditingController(text: pref?.birthDate),
                enabled: false,
                decoration: InputDecoration(
                  labelText: locale.getText('birthday'),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
