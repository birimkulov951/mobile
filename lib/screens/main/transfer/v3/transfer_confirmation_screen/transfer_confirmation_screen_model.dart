import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/transfer_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_model.dart';

class TransferConfirmationScreenModel extends ElementaryModel
    with TransferMixin {
  TransferConfirmationScreenModel(
      {required TransferRepository transferRepository}) {
    this.transferRepository = transferRepository;
  }


}
