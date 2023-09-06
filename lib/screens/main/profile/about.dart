import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/app_config.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/url_launcher.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, result) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 21),
                  child: SvgPicture.asset('assets/graphics/paynet.svg'),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextLocale(
                    'about_desc',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorNode.Dark3,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    sprintf(locale.getText('version'), [
                      result.data?.version ?? '',
                      Config.isDebug
                          ? '${result.data?.buildNumber}-dev'
                          : result.data?.buildNumber
                    ]),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorNode.Grey5C),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  child: GestureDetector(
                    child: const Text(
                      'www.paynet.uz',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorNode.Link,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                      final canLaunch =
                          await UrlLauncher.canLaunchUrl(Const.pynetDomain);
                      if (canLaunch) {
                        await UrlLauncher.launchUrl(
                          Const.pynetDomain,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => showMessage(
                                context,
                                locale.getText('error'),
                                locale.getText('unavailable')));
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
}
