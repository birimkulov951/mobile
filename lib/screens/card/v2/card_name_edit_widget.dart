import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/screens/base/base_inherited_theme.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class CardNameEditWdiget extends StatefulWidget {
  final String oldName;

  const CardNameEditWdiget({
    this.oldName = '',
  });

  @override
  State<StatefulWidget> createState() => CardNameEditWdigetState();
}

class CardNameEditWdigetState extends BaseInheritedTheme<CardNameEditWdiget> {
  final _cardNameCtrl = TextEditingController();

  bool hiddenSuffix = true;

  @override
  void initState() {
    super.initState();
    _cardNameCtrl.text = widget.oldName;
    hiddenSuffix = _cardNameCtrl.text.isEmpty;
  }

  @override
  void dispose() {
    _cardNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget get formWidget {
    return Container(
      decoration: BoxDecoration(
          color: ColorNode.Main,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemContainer(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Title1(
                  text: 'rename_card',
                  size: 22,
                  weight: FontWeight.w700,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(
                  height: 24,
                ),
                LocaleBuilder(
                  builder: (_, locale) => TextField(
                    controller: _cardNameCtrl,
                    textInputAction: TextInputAction.done,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: locale.getText('card_name'),
                      suffixIcon: hiddenSuffix
                          ? null
                          : IconButton(
                              icon: SvgPicture.asset(
                                  'assets/graphics_redesign/clear.svg'),
                              onPressed: () => setState(() {
                                hiddenSuffix = true;
                                _cardNameCtrl.text = '';
                              }),
                            ),
                    ),
                    onSubmitted: (value) => acceptCardName(),
                    onChanged: (value) {
                      if (hiddenSuffix) {
                        setState(() => hiddenSuffix = false);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 230),
          RoundedButton(
            title: 'save_changes',
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: _getBottomPadding(context),
            ),
            onPressed: acceptCardName,
          )
        ],
      ),
    );
  }

  void acceptCardName() => Navigator.pop(context, _cardNameCtrl.text);

  double _getBottomPadding(BuildContext context) {
    final bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
    return bottomViewPadding == 0 ? 24 : bottomViewPadding;
  }
}
