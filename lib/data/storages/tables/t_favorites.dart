class TFavorites {
  static const String NAME = 'favorites';

  static const ID = 'id';
  static const TITLE = 'title';
  static const BILL = 'bill';
  static const BILL_ID = 'bill_id';
  static const ORDER = 'ord';

  static const SQL = "CREATE TABLE $NAME("
      "$ID INTEGER, "
      "$TITLE TEXT, "
      "$BILL TEXT, "
      "$BILL_ID INTEGER,"
      "$ORDER INTEGER)";

  static const AT_ORDER = 'ALTER TABLE $NAME ADD COLUMN $ORDER INTEGER';
}
