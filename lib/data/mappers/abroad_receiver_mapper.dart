import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/abroad_receiver_response.dart';
import 'package:mobile_ultra/data/mappers/entity_mapper_base.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';



@Singleton()
class AbroadReceiverMapper extends CommonMapperBase<
    AbroadTransferReceiverEntity, AbroadReceiverResponse> {
  @override
  AbroadReceiverResponse toDTO(AbroadTransferReceiverEntity entity) {
    return AbroadReceiverResponse(
      pan: entity.pan,
      maskedPan: entity.maskedPan,
      bankName: entity.bankName,
      logoUrl: entity.bankIconUrl,
    );
  }

  @override
  AbroadTransferReceiverEntity toEntity(AbroadReceiverResponse dto) {
    return AbroadTransferReceiverEntity(
      pan: dto.pan,
      maskedPan: dto.maskedPan,
      bankName: dto.bankName,
      bankIconUrl: dto.logoUrl,
    );
  }
}
