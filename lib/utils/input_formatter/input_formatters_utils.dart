import 'package:flutter/services.dart';
import 'package:mobile_ultra/utils/reg_exp_utils.dart';

late final numberFormatter =
    FilteringTextInputFormatter.allow(numberFormatterRegExp);
