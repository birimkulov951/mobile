import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class HistoryButton extends StatefulWidget {
  final String title;
  final bool isPressed;
  final String? leadingIcon;
  final Widget? trailingIcon;
  final Function() onTap;

  const HistoryButton({
    required this.title,
    required this.onTap,
    this.isPressed = false,
    this.trailingIcon,
    this.leadingIcon,
    super.key,
  });

  @override
  State<HistoryButton> createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<HistoryButton> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              child: Material(
                child: InkWell(
                  onTap: widget.onTap,
                  child: Ink(
                    padding: EdgeInsets.only(
                      top: 8,
                      left: widget.leadingIcon != null ? 12 : 16,
                      right: widget.trailingIcon != null ||
                              widget.leadingIcon != null
                          ? 12
                          : 16,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isPressed && widget.leadingIcon == null
                          ? ControlColors.accent
                          : ControlColors.secondaryActive,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.leadingIcon != null)
                          SvgPicture.asset(
                            widget.leadingIcon!,
                            height: 16,
                            color: ColorNode.Dark1,
                          ),
                        Text(
                          widget.title,
                          style: Typographies.captionButton.copyWith(
                              color: widget.isPressed
                                  ? TextColors.constant
                                  : TextColors.primary),
                        ),
                        if (widget.trailingIcon != null) ...[
                          const SizedBox(width: 8),
                          widget.trailingIcon!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (widget.leadingIcon != null && widget.isPressed)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BackgroundColors.primary,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ControlColors.primaryActive,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
