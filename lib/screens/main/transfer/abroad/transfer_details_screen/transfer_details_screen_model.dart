import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/repositories/transfer_abroad_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_rate_model.dart';

/// Модель для экран деталей перевода за границу
class TransferDetailsScreenModel extends ElementaryModel
    with TransferRateModelMixin {
  TransferDetailsScreenModel({
    required this.transferAbroadRepository,
  });

  @override
  @protected
  final TransferAbroadRepository transferAbroadRepository;
}
