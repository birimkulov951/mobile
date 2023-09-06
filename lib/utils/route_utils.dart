import 'package:flutter/material.dart';

bool getBoolArgumentFromContext(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments;
  if (arguments is! bool?) {
    return false;
  }

  return arguments ?? false;
}

List<dynamic>? getListArgumentFromContext(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments;
  return arguments is List<dynamic>? ? arguments : [];
}
