import 'package:mobile_ultra/data/api/dto/responses/payment/category_response.dart';
import 'package:mobile_ultra/data/hive/payment/category_hive_object.dart';
import 'package:mobile_ultra/domain/payment/category_entity.dart';

extension CategoryHiveObjectToEntity on CategoryHiveObject {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      nameEn: nameEn,
      displayOrder: displayOrder,
    );
  }
}

extension CategoryResponseToHiveObject on CategoryResponse {
  CategoryHiveObject toHiveObject() {
    return CategoryHiveObject(
      id: id,
      nameRu: nameRu,
      nameUz: nameUz,
      nameEn: nameEn,
      displayOrder: displayOrder,
    );
  }
}
