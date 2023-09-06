import 'package:equatable/equatable.dart';

class CategoryEntity with EquatableMixin {
  CategoryEntity({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.nameEn,
    required this.displayOrder,
  });

  final int id;
  final String nameRu;
  final String nameUz;
  final String nameEn;
  final int displayOrder;

  @override
  List<Object?> get props => [id, nameRu, nameUz, nameEn, displayOrder];

  @override
  String toString() {
    return 'CategoryEntity {'
        'id: $id, '
        'nameRu: $nameRu, '
        'nameUz: $nameUz, '
        'nameEn: $nameEn, '
        'displayOrder: $displayOrder'
        '}';
  }
}
