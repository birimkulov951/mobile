import 'package:mobile_ultra/data/api/dto/requests/cards/card_addition_request.dart';
import 'package:mobile_ultra/data/api/dto/requests/cards/card_edit_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/card_addition_response.dart';
import 'package:mobile_ultra/data/api/dto/responses/cards/card_beans_response.dart';
import 'package:mobile_ultra/domain/cards/card_addition_entity.dart';
import 'package:mobile_ultra/domain/cards/card_addition_req_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';

extension CardAdditionEntityExt on CardAdditionResponse {
  CardAdditionEntity toEntity() {
    return CardAdditionEntity(
      id: id,
      token: token,
      name: name,
      maskedPan: maskedPan,
      status: status,
      phone: phone,
      balance: balance,
      sms: sms,
      bankId: bankId,
      login: login,
      main: main,
      color: color,
      expireDate: expireDate,
      createdDate: createdDate,
      activated: activated,
      order: order,
      activatedDate: activatedDate,
      bankName: bankName,
      type: type,
      p2pEnabled: p2pEnabled,
      subscribed: subscribed,
      subscribeLastDate: subscribeLastDate,
      entryCount: entryCount,
      valid: valid,
      maskedPhone: maskedPhone,
    );
  }
}

extension CardAdditionReqEntityExt on CardAdditionReqEntity {
  CardAdditionRequest toRequest() {
    return CardAdditionRequest(
      color: color,
      expiry: expiry,
      main: main,
      pan: pan,
      name: name,
      order: order,
      token: token,
      type: type,
    );
  }
}

extension CardBeansEntityExt on CardBeansResponse {
  CardBeansEntity toEntity() {
    return CardBeansEntity(
      humo: humo,
      uzcard: uzcard,
    );
  }
}

extension CardEditEntityToRequestExt on CardEditEntity {
  CardEditRequest toRequest() {
    return CardEditRequest(
      name: name,
      color: color,
      main: main,
      order: order,
      token: token,
    );
  }
}
