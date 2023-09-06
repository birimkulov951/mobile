import 'package:mobile_ultra/ui_models/various/fpi_widget.dart';

class FPI {
  final FPIType type;
  final String title;
  final int merchantId;
  final String merchantName;
  final String account;
  final String payBill;

  FPI({
    required this.type,
    required this.title,
    required this.merchantId,
    required this.merchantName,
    required this.account,
    required this.payBill,
  });
}
