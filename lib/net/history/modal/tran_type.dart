enum TranType {
  p2p('P2P'),
  debit('DEBIT'),
  credit('CREDIT'),
  ok('OK'),
  reversal('REVERSAL'),
  xbP2p('XB_P2P'),
  uzcardHumo('UZCARD_HUMO_P2P'),
  humoHumo('HUMO_HUMO_P2P'),
  uzcardUzcard('UZCARD_UZCARD_P2P'),
  humoUzcard('HUMO_UZCARD_P2P');

  final String value;

  const TranType(this.value);
}


