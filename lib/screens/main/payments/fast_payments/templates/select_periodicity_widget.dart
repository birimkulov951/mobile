import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class SelectPeriodicityWidget extends StatefulWidget {
  final bool everyWeek;
  final int period;

  SelectPeriodicityWidget({
    this.everyWeek = true,
    this.period = 1,
  });

  @override
  State<StatefulWidget> createState() => _SelectPeriodicityWidgetState();
}

class _SelectPeriodicityWidgetState extends State<SelectPeriodicityWidget> {
  final List<String> weeklyItemsTitle = [
    locale.getText('mon'),
    locale.getText('tue'),
    locale.getText('wed'),
    locale.getText('thu'),
    locale.getText('fri'),
    locale.getText('sat'),
    locale.getText('sun'),
  ];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentPage = widget.period - 1;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Title1(
            text:
                widget.everyWeek ? 'select_day_of_week' : 'select_day_of_month',
            padding: const EdgeInsets.only(left: 16, top: 24),
            size: 18,
            weight: FontWeight.w700,
          ),
          Container(
            height: 204,
            color: ColorNode.Main,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcOut),
                  child: Container(
                    width: double.maxFinite,
                    height: 204,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.dstOut),
                    child: Center(
                      child: Container(
                        width: 328,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 204,
                  child: widget.everyWeek ? dayOfWeek : dayOfMonth,
                )
              ],
            ),
          ),
          RoundedButton(
            key: const Key(WidgetIds.periodicitySelectButton),
            margin: const EdgeInsets.all(16),
            title: 'continue',
            onPressed: () => Navigator.pop(context, currentPage + 1),
          )
        ],
      );

  Widget get dayOfWeek => PageView.builder(
        controller: PageController(
            initialPage: widget.period - 1, viewportFraction: .2),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: weeklyItemsTitle.length,
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          child: Title1(
            text: weeklyItemsTitle[index],
            size: 18,
            color:
                currentPage != index ? ColorNode.GreyScale500 : ColorNode.Dark3,
          ),
        ),
        onPageChanged: (page) => setState(() => currentPage = page),
      );

  Widget get dayOfMonth => PageView.builder(
        controller: PageController(
            initialPage: widget.period - 1, viewportFraction: .2),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 31,
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          child: Title1(
            text: '${index + 1}',
            size: 18,
            color:
                currentPage != index ? ColorNode.GreyScale500 : ColorNode.Dark3,
          ),
        ),
        onPageChanged: (page) => setState(() => currentPage = page),
      );
}
