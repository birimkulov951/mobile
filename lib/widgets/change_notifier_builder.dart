import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangeNotifierBuilder<T> extends StatefulWidget {
  const ChangeNotifierBuilder({
    Key? key,
    required this.changeNotifier,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ChangeNotifier changeNotifier;

  final WidgetBuilder builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ChangeNotifierBuilderState<T>();
}

class _ChangeNotifierBuilderState<T> extends State<ChangeNotifierBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.changeNotifier.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(ChangeNotifierBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.changeNotifier != widget.changeNotifier) {
      oldWidget.changeNotifier.removeListener(_onChanged);
      widget.changeNotifier.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.changeNotifier.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
