import 'package:flutter/material.dart';

class BasicCell extends StatelessWidget {
  const BasicCell({
    Key? key,
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
    this.helper,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.isTrailingInTitle = false,
    this.isOpaque = true,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? leading;
  final Widget? title;
  final Widget? subTitle;
  final Widget? trailing;
  final Widget? helper;
  final bool isTrailingInTitle;
  final bool isOpaque;

  Widget _getLeading() {
    if (leading == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [leading!, SizedBox(width: 12)],
    );
  }

  Widget _getTitle() {
    if (title == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Expanded(child: title!),
        Visibility(
          visible: isTrailingInTitle,
          child: _getTrailing(),
        )
      ],
    );
  }

  Widget _getSubTitle() {
    if (subTitle == null) {
      return const SizedBox.shrink();
    }
    return subTitle!;
  }

  Widget _getTrailing() {
    if (trailing == null) {
      return const SizedBox.shrink();
    }
    return trailing!;
  }

  Widget getBodySpace() {
    if (title != null && subTitle != null) {
      if (helper != null) {
        return SizedBox(height: 2);
      }
      return SizedBox(height: 4);
    }
    return const SizedBox.shrink();
  }

  Widget _getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTitle(),
        getBodySpace(),
        _getSubTitle(),
      ],
    );
  }

  Widget getHelper() {
    if (helper == null) {
      return const SizedBox.shrink();
    }
    return Column(children: [
      const SizedBox(height: 4),
      helper!,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: isOpaque ? 1 : 0.4,
            child: _getLeading(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: isOpaque ? 1 : 0.4,
                  child: _getBody(),
                ),
                getHelper(),
              ],
            ),
          ),
          Opacity(
            opacity: isOpaque ? 1 : 0.4,
            child: Visibility(
              visible: !isTrailingInTitle,
              child: _getTrailing(),
            ),
          ),
        ],
      ),
    );
  }
}
