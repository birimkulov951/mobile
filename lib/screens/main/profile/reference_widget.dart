import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/ui_models/rows/category_row_item.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Title1(
            text: 'reference',
            size: 22,
            weight: FontWeight.w700,
            padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
          ),
          CategoryRowItem(
              leading: Padding(
                padding: const EdgeInsets.all(0),
                child: SvgPicture.asset('assets/graphics_redesign/file.svg'),
              ),
              leadingColor: Colors.white,
              title: 'public_offer',
              onTap: () async {
                if (await UrlLauncher.canLaunchUrl(Const.PUBLIC_OFFER))
                  UrlLauncher.launchUrl(
                    Const.PUBLIC_OFFER,
                    mode: LaunchMode.externalApplication,
                  );
                else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => showMessage(
                          context,
                          locale.getText('error'),
                          locale.getText('unavailable'),
                          onSuccess: () => Navigator.pop(context)));
                }
              }),
          /*CategoryRowItem(
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: SvgPicture.asset('assets/graphics_redesign/file_lock.svg'),
        ),
        leadingColor: Colors.white,
        title: locale.getText('privacy_policy'),
        onTap: () async {
          if (await canLaunch('https://map.paynet.uz'))
            launch('https://map.paynet.uz');
          else {
            showDialog(
              context: context,
              builder: (BuildContext context) => showMessage(
                context,
                locale.getText('error'),
                locale.getText('unavailable'),
                onSuccess: () => Navigator.pop(context)
              )
            );
          }
        }
      ),
      CategoryRowItem(
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: SvgPicture.asset('assets/graphics_redesign/file_settings.svg'),
        ),
        leadingColor: Colors.white,
        title: locale.getText('terms_of_use'),
        onTap: () async {
          if (await canLaunch('https://map.paynet.uz'))
            launch('https://map.paynet.uz');
          else {
            showDialog(
              context: context,
              builder: (BuildContext context) => showMessage(
                context,
                locale.getText('error'),
                locale.getText('unavailable'),
                onSuccess: () => Navigator.pop(context)
              )
            );
          }
        }
      ),*/
          const SizedBox(height: 94)
        ],
      );
}
