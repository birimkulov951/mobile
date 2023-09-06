import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_hive_object.g.dart';

@HiveType(typeId: 0)
class CategoryHiveObject extends HiveObject with EquatableMixin {
  CategoryHiveObject({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.nameEn,
    required this.displayOrder,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nameRu;

  @HiveField(2)
  final String nameUz;

  @HiveField(3)
  final String nameEn;

  @HiveField(4)
  final int displayOrder;

  @override
  List<Object?> get props => [id, nameRu, nameUz, nameEn, displayOrder];

  @override
  String toString() {
    return 'CategoryHiveObject {'
        'id: $id, '
        'nameRu: $nameRu, '
        'nameUz: $nameUz, '
        'nameEn: $nameEn, '
        'displayOrder: $displayOrder'
        '}';
  }
}
