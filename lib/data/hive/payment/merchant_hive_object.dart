import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'merchant_hive_object.g.dart';

@HiveType(typeId: 1)
class MerchantHiveObject extends HiveObject with EquatableMixin {
  MerchantHiveObject({
    this.id = -1,
    this.nameRu = '',
    this.nameUz = '',
    this.nameEn = '',
    this.displayOrder = 0,
    this.categoryId = -1,
    this.infoServiceId ,
    this.paymentServiceId,
    this.cancelServiceId,
    this.minAmount = 0.0,
    this.maxAmount = 0.0,
    this.legalName = '',
    this.servicePrice = -1,
    this.printInfoCheque = -1,
    this.printPayCheque = -1,
    this.topSelected = 0,
    this.bonus = 0.0,
    this.isActive = true,
  });

  @HiveField(0, defaultValue: -1)
  final int id;
  @HiveField(1, defaultValue: '')
  final String nameRu;
  @HiveField(2, defaultValue: '')
  final String nameUz;
  @HiveField(3, defaultValue: '')
  final String nameEn;
  @HiveField(4, defaultValue: 0)
  final int displayOrder;
  @HiveField(5, defaultValue: -1)
  final int categoryId;
  @HiveField(6, defaultValue: null)
  final int? infoServiceId;
  @HiveField(7, defaultValue: null)
  final int? paymentServiceId;
  @HiveField(8, defaultValue: null)
  final int? cancelServiceId;
  @HiveField(9, defaultValue: 0.0)
  final double minAmount;
  @HiveField(10, defaultValue: 0.0)
  final double maxAmount;
  @HiveField(11, defaultValue: '')
  final String legalName;
  @HiveField(12, defaultValue: -1)
  final int servicePrice;
  @HiveField(13, defaultValue: -1)
  final int printInfoCheque;
  @HiveField(14, defaultValue: -1)
  final int printPayCheque;
  @HiveField(15, defaultValue: 0)
  final int topSelected;
  @HiveField(16, defaultValue: 0.0)
  final double bonus;
  @HiveField(17, defaultValue: true)
  final bool isActive;

  @override
  List<Object?> get props => [
        id,
        nameRu,
        nameUz,
        nameEn,
        displayOrder,
        categoryId,
        infoServiceId,
        paymentServiceId,
        cancelServiceId,
        minAmount,
        maxAmount,
        legalName,
        servicePrice,
        printInfoCheque,
        printPayCheque,
        topSelected,
        bonus,
        isActive,
      ];

  @override
  String toString() {
    return 'MerchantHiveObject {'
        'id: $id, '
        'nameRu: $nameRu, '
        'nameUz: $nameUz, '
        'nameEn: $nameEn, '
        'displayOrder: $displayOrder, '
        'cagetoryId: $categoryId, '
        'infoServiceId: $infoServiceId, '
        'paymentServiceId: $paymentServiceId, '
        'cancelServiceId: $cancelServiceId, '
        'minAmount: $minAmount, '
        'maxAmount: $maxAmount, '
        'legalName: $legalName, '
        'servicePrice: $servicePrice, '
        'printInfoCheQue: $printInfoCheque, '
        'printPayCheQue: $printPayCheque, '
        'topSelected: $topSelected, '
        'bonus: $bonus, '
        'isActive: $isActive'
        '}';
  }
}
