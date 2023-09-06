import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/repositories/system_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_model.dart';

class TransferBanksScreenModel extends ElementaryModel
    with SystemModelMixin {
  TransferBanksScreenModel({
    required SystemRepository systemRepository,
    required TransferRepository transferByPhoneNumberRepository,
  }) : _transferByPhoneNumberRepository = transferByPhoneNumberRepository {
    this.systemRepository = systemRepository;
  }

  final TransferRepository _transferByPhoneNumberRepository;

  Future<CardsByPhoneNumberEntity?> getCardsByPhoneNumber(
      String phoneNumber) async {
    try {
      return await _transferByPhoneNumberRepository
          .getCardsByPhoneNumber(phoneNumber);
    } on Object catch (error) {
      this.handleError(error);
      return null;
    }
  }
}
