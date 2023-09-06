/// Field types:
///
/// A - amount,
/// P - phone,
/// I - use check prepaid method,
/// Q - read only and defaul value is 1
/// U - use method to get new fields,
/// P - prefix,
/// C - account number,
/// S - service id,
/// J - use check method twice, first to show info, second to get new billId and make pay at once
/// F - addition information. field that have this type can be not required

class MerchantField {
  final int? id;
  final String type;
  final String typeName;
  final String? label;
  final int? fieldSize;
  final String? controlType;
  final String? controlTypeInfo;
  final String? parentId;
  final List<MerchantFieldValue?>? values;
  bool? readOnly;
  final dynamic defaultValue;
  final bool? isRequired;
  bool? isHidden;

  MerchantField({
    this.id,
    String? type,
    String? typeName,
    required this.label,
    this.fieldSize,
    this.controlType,
    this.controlTypeInfo,
    this.parentId,
    this.values,
    this.readOnly = false,
    this.defaultValue,
    this.isRequired = true,
    this.isHidden = false,
  })  : type = type ?? 'unknown',
        typeName = typeName ?? 'unknown';

  @override
  String toString() {
    return 'MerchantField{id: $id, type: $type, typeName: $typeName, label: $label, fieldSize: $fieldSize, controlType: $controlType, controlTypeInfo: $controlTypeInfo, parentId: $parentId, values: $values, readOnly: $readOnly, defaultValue: $defaultValue, isRequired: $isRequired, isHidden: $isHidden}';
  }
}

class MerchantFieldValue {
  final int id;
  final String? fieldValue;
  final String label;
  final int? amount;
  final String? prefix;
  final String? checkId;
  final String? parentId;

  MerchantFieldValue({
    required this.id,
    required this.fieldValue,
    required this.label,
    required this.amount,
    required this.prefix,
    required this.checkId,
    required this.parentId,
  });
}
