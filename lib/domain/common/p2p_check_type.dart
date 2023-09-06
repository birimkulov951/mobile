//CARD_ID, //не используется, но не уверен
//LOGIN, // Возможно надо использовать PHONE вмето него
//USER_ID, не используется
//USER_HASH, не используется
//PAYSYS_PAN, не используется
//HUMO_PAN не используется*/
enum P2PCheckType {
  cardId('CARD_ID'),
  cardToken('CARD_TOKEN'),
  phone('PHONE'),
  pan('PAN');

const P2PCheckType(this.value);

final String value;
}

extension P2PTypeExtension on String {
  P2PCheckType toP2PCheckType() {
    if (this == P2PCheckType.cardId.value) {
      return P2PCheckType.cardId;
    } else if (this == P2PCheckType.cardToken.value) {
      return P2PCheckType.cardToken;
    } else if (this == P2PCheckType.phone.value) {
      return P2PCheckType.phone;
    } else {
      return P2PCheckType.pan;
    }
  }
}
