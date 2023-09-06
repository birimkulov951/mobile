class TCardBean {
  static const String NAME = 'card_bean';

  static const CARD_TYPE = 'card_type';
  static const BEAN = 'bean';

  static const SQL = "CREATE TABLE $NAME("
      "$CARD_TYPE INTEGER, "
      "$BEAN TEXT)";
}
