import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class AddingTemplateResult extends StatefulWidget {
  final bool bySchedule;

  const AddingTemplateResult({
    this.bySchedule = false,
  });

  @override
  State<StatefulWidget> createState() => _AddingTemplateResultState();
}

class _AddingTemplateResultState
    extends BaseInheritedTheme<AddingTemplateResult> {
  @override
  Widget get formWidget => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Spacer(),
            SvgPicture.asset('assets/graphics_redesign/success.svg'),
            Title1(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              text: widget.bySchedule
                  ? 'templates_by_schedule_saved'
                  : 'templates_saved',
              weight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            Title1(
              padding: const EdgeInsets.only(left: 16, right: 16),
              text: 'templates_success_hint',
              size: 14,
              color: ColorNode.MainSecondary,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ItemContainer(
                backgroundColor: ColorNode.Background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: RoundedButton(
                  key: const Key(WidgetIds.addingTemplateSuccess),
                  margin: EdgeInsets.fromLTRB(16, 24, 16,
                      MediaQuery.of(context).viewPadding.bottom + 16),
                  title: 'done',
                  onPressed: () => Navigator.pop(context),
                ))
          ],
        ),
      );
}
