import 'package:json_annotation/json_annotation.dart';

part 'merchant_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MerchantResponse {
  MerchantResponse({
    this.id = -1,
    this.nameRu = '',
    this.nameUz = '',
    this.nameEn = '',
    this.displayOrder = 0,
    this.categoryId = -1,
    this.infoServiceId,
    this.paymentServiceId ,
    this.cancelServiceId ,
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
  @JsonKey(name: 'topselected')
  final int topSelected;
  final double bonus;
  final bool isActive;

  factory MerchantResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantResponseToJson(this);

}
