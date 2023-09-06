class TFields {
  static const String NAME = 'fields';

  static const ID = 'id';
  static const MERCHANT_ID = 'merchant_id';
  static const TYPE_NAME = 'type_name';
  static const TYPE = 'type';
  static const NAME_RU = 'name_ru';
  static const NAME_UZ = 'name_uz';
  static const NAME_EN = 'name_en';
  static const NAME_ = 'name_';
  static const FIELD_SIZE = 'field_size';
  static const CONTROL_TYPE = 'control_type';
  static const CONTROL_TYPE_INFO = 'control_type_info';
  static const PARENT_ID = 'parent_id';
  static const REQUIRED = 'required_field';
  static const ORDER = 'ord';

  static const SQL = "CREATE TABLE $NAME("
          "$ID INTEGER, "
          "$MERCHANT_ID INTEGER, "
          "$TYPE_NAME TEXT, "
          "$TYPE TEXT, "
          "$NAME_RU TEXT, "
          "$NAME_UZ TEXT, $NAME_EN TEXT, "
          "$FIELD_SIZE INTEGER, "
          "$CONTROL_TYPE TEXT, "
          "$CONTROL_TYPE_INFO TEXT, " +
      "$PARENT_ID TEXT, "
          "$REQUIRED INTEGER, "
          "$ORDER INTEGER)";

  static const AT_REQUIRED =
      'ALTER TABLE $NAME ADD COLUMN $REQUIRED INTEGER DEFAULT 1';
}
