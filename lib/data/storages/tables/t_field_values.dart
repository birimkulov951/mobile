class TFieldValues {
  static const String NAME = 'field_values';

  static const ID = 'id';
  static const FIELD_ID = 'field_id';
  static const FIELD_VALUE = 'field_value';
  static const NAME_RU = 'name_ru';
  static const NAME_UZ = 'name_uz';
  static const NAME_EN = 'name_en';
  static const NAME_ = 'name_';
  static const AMOUNT = 'amount';
  static const PREFIX = 'prefix';
  static const PARENT_ID = 'parent_id';
  static const CHECK_ID = 'check_id';
  static const ORDER = 'ord';

  static const SQL = "CREATE TABLE $NAME($ID INTEGER, $FIELD_ID INTEGER, " +
      "$FIELD_VALUE TEXT, $NAME_RU TEXT, $NAME_UZ TEXT, $NAME_EN TEXT, " +
      "$AMOUNT INTEGER, $PREFIX TEXT, $PARENT_ID TEXT, $CHECK_ID TEXT, $ORDER INTEGER)";
}
