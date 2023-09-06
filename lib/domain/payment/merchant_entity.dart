import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';

class MerchantEntity with EquatableMixin {
  MerchantEntity({
    this.id = -1,
    this.nameRu = '',
    this.nameUz = '',
    this.nameEn = '',
    this.displayOrder = 0,
    this.categoryId = -1,
    this.infoServiceId,
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

  final int id;
  final String nameRu;
  final String nameUz;
  final String nameEn;
  final int displayOrder;
  final int categoryId;
  final int? infoServiceId;
  final int? paymentServiceId;
  final int? cancelServiceId;
  final double minAmount;
  final double maxAmount;
  final String legalName;
  final int servicePrice;
  final int printInfoCheque;
  final int printPayCheque;
  final int topSelected;
  final double bonus;
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
    return 'MerchantEntity {'
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

extension NameLocalization on MerchantEntity {
  String get name {
    switch (LocaleHelper.currentLangCode) {
      case LocaleHelper.Russian:
        return nameRu;
      case LocaleHelper.Uzbek:
        return nameUz;
      case LocaleHelper.English:
        return nameEn;
      default:
        return '';
    }
  }
}
