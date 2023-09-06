import 'package:flutter/material.dart';

class ItemPadding extends StatelessWidget {
  const ItemPadding({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: child,
    );
  }
}
