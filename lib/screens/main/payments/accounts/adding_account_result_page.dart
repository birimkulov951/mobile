import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';

class AddingAccountResultPage extends StatefulWidget {
  const AddingAccountResultPage();

  @override
  State<StatefulWidget> createState() => _AddingAccountResultPageState();
}

class _AddingAccountResultPageState
    extends BaseInheritedTheme<AddingAccountResultPage> {
  @override
  Widget get formWidget => WillPopScope(
        onWillPop: () async {
          _onSuccessResult();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(Assets.success),
              const SizedBox(height: Dimensions.unit1_5),
              Title1(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.unit1_5,
                  horizontal: Dimensions.unit2,
                ),
                text: 'account_added',
                weight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
              Title1(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.unit2,
                ),
                text: 'account_added_hint',
                size: 14,
                color: ColorNode.MainSecondary,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ItemContainer(
                backgroundColor: ColorNode.Background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.unit3),
                ),
                child: RoundedButton(
                  margin: EdgeInsets.only(
                      left: Dimensions.unit2,
                      top: Dimensions.unit3,
                      right: Dimensions.unit2,
                      bottom: MediaQuery.of(context).viewPadding.bottom +
                          Dimensions.unit2),
                  title: 'done',
                  onPressed: _onSuccessResult,
                ),
              ),
            ],
          ),
        ),
      );

  void _onSuccessResult() => Navigator.pop(context, true);
}
