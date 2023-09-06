import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:ui_kit/ui_kit.dart';

class SearchInputV2 extends OrdinaryInput {
  SearchInputV2({
    Key? key,
    required FocusNode focusNode,
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onClearTap,
  }) : super(
          onClearTap: onClearTap,
          focusNode: focusNode,
          controller: controller,
          height: 44,
          hintText: hintText,
          prefix: ActionIcons.search.copyWith(
            height: 16,
            width: 16,
          ),
          textInputAction: TextInputAction.search,
        );

  @override
  State<StatefulWidget> createState() => _SearchInputV2State();
}

class _SearchInputV2State extends OrdinaryInputState {
  @override
  Widget build(BuildContext context) => super.build(context);
}
