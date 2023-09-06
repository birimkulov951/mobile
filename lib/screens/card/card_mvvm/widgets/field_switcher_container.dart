import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/domain/cards/field_switcher.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';

const _fieldSwitcherHeight = 48.0;

class FieldSwitcherContainer extends StatelessWidget {
  const FieldSwitcherContainer({
    Key? key,
    required this.fieldSwitcherData,
    required this.onReadyButtonTap,
    required this.onPrev,
    required this.onNext,
  }) : super(key: key);

  final FieldSwitcher fieldSwitcherData;
  final Function() onReadyButtonTap;
  final Function() onPrev;
  final Function() onNext;

  @override
  Widget build(BuildContext context) {
    if (fieldSwitcherData.isFieldSwitcherHidden) {
      return const SizedBox.shrink();
    }
    return Container(
      height: _fieldSwitcherHeight,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: BackgroundColors.modal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                key: const Key(WidgetIds.cardAdditionPrevButton),
                onTap: onPrev,
                child: SvgPicture.asset(
                  Assets.chevronUp,
                  color: fieldSwitcherData.hasPrevious
                      ? ControlColors.accent
                      : ControlColors.accentDisabled,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                key: const Key(WidgetIds.cardAdditionNextButton),
                onTap: onNext,
                child: SvgPicture.asset(
                  Assets.chevronDown,
                  color: fieldSwitcherData.hasNext
                      ? ControlColors.accent
                      : ControlColors.accentDisabled,
                ),
              ),
            ],
          ),
          TextButton(
            key: const Key(WidgetIds.cardAdditionReadyButton),
            onPressed: onReadyButtonTap,
            child: TextLocale(
              'ready',
              style: Typographies.captionButtonSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
