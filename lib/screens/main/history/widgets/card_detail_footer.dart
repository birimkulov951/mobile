import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/main.dart' show locale;

class CardDetailFooter extends StatelessWidget {
  final bool hasAddButton;
  final bool hasDownloadButton;
  final Function() onTap;
  final Function() onTaps;

  const CardDetailFooter({
    Key? key,
    this.hasAddButton = false,
    this.hasDownloadButton = false,
    required this.onTap,
    required this.onTaps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = listOfButtons(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buttons,
      ),
    );
  }

  List<Widget> listOfButtons(BuildContext context) {
    return [
      if (hasAddButton)
        roundButton(
          iconData: Icons.add,
          title: locale.getText("save_template"),
          onTap: onTaps,
        ),
      if (hasDownloadButton)
        roundButton(
          iconData: Icons.download_sharp,
          title: locale.getText("download_file"),
          onTap: onTap,
        ),
    ];
  }

  Widget roundButton({
    IconData? iconData,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      width: 88,
      margin: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: ColorNode.Dark4,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                size: 24,
                color: ColorNode.ContainerColor,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorNode.Dark3,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
