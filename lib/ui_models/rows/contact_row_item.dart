import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

import 'package:utils/module/contact.dart';
import 'package:mobile_ultra/utils/u.dart';

class ContactRowItem extends StatelessWidget {
  final Contact contact;
  final Function(String) onSelectPhone;

  ContactRowItem({
    required this.contact,
    required this.onSelectPhone,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onSelectPhone(contact.phone),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SvgPicture.asset(Assets.call),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: TextStyles.textRegular,
                    ),
                    Text(
                      formatPayeeLogin(contact.phone),
                      style: TextStyles.caption1MainSecondary,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.keyboard_arrow_right,
                color: ColorNode.MainSecondary,
              ),
            ],
          ),
        ),
      );
}
