import 'package:mobile_ultra/data/api/dto/responses/payment/merchant_response.dart';
import 'package:mobile_ultra/data/hive/payment/merchant_hive_object.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';

extension MerchantHiveObjectToEntity on MerchantHiveObject {
  MerchantEntity toEntity() {
    return MerchantEntity(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      nameEn: nameEn,
      displayOrder: displayOrder,
      categoryId: categoryId,
      infoServiceId: infoServiceId,
      paymentServiceId: paymentServiceId,
      cancelServiceId: cancelServiceId,
      minAmount: minAmount,
      maxAmount: maxAmount,
      legalName: legalName,
      servicePrice: servicePrice,
      printInfoCheque: printInfoCheque,
      printPayCheque: printPayCheque,
      topSelected: topSelected,
      bonus: bonus,
      isActive: isActive,
    );
  }
}

extension MerchantResponseToHiveObject on MerchantResponse {
  MerchantHiveObject toHiveObject() {
    return MerchantHiveObject(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      nameEn: nameEn,
      displayOrder: displayOrder,
      categoryId: categoryId,
      infoServiceId: infoServiceId,
      paymentServiceId: paymentServiceId,
      cancelServiceId: cancelServiceId,
      minAmount: minAmount,
      maxAmount: maxAmount,
      legalName: legalName,
      servicePrice: servicePrice,
      printInfoCheque: printInfoCheque,
      printPayCheque: printPayCheque,
      topSelected: topSelected,
      bonus: bonus,
      isActive: isActive,
    );
  }
}
