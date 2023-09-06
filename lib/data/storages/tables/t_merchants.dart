class TMerchants {
  static const String NAME = 'merchants';

  static const ID = 'id';
  static const CATEGORY_ID = 'category_id';
  static const NAME_RU = 'name_ru';
  static const NAME_UZ = 'name_uz';
  static const NAME_EN = 'name_en';
  static const NAME_ = 'name_';
  static const TOP = 'top';
  static const INFO_SERVICE_ID = 'info_service_id';
  static const PAYMENT_SERVICE_ID = 'payment_service_id';
  static const CANCEL_SERVICE_ID = 'cancel_service_id';
  static const MIN_AMOUNT = 'min_amount';
  static const MAX_AMOUNT = 'max_amount';
  static const DISPLAY_ORDER = 'display_order';
  static const LEGAL_NAME = 'legal_name';
  static const SERVICE_PRICE = 'service_price';
  static const PRINT_INFO_CHEQUE = 'print_info_cheque';
  static const PRINT_PAY_CHEQUE = 'print_pay_cheque';
  static const BONUS = 'bonus';
  static const IS_ACTIVE = 'is_active';

  static const SQL = "CREATE TABLE $NAME("
      "$ID INTEGER,"
      "$CATEGORY_ID INTEGER, "
      "$NAME_RU TEXT, "
      "$NAME_UZ TEXT, "
      "$NAME_EN TEXT, "
      "$TOP INTEGER, "
      "$INFO_SERVICE_ID INTEGER, "
      "$PAYMENT_SERVICE_ID INTEGER, "
      "$CANCEL_SERVICE_ID INTEGER, "
      "$MIN_AMOUNT INTEGER, "
      "$MAX_AMOUNT INTEGER, "
      "$DISPLAY_ORDER INTEGER, "
      "$LEGAL_NAME TEXT, "
      "$SERVICE_PRICE INTEGER, "
      "$PRINT_INFO_CHEQUE INTEGER, "
      "$PRINT_PAY_CHEQUE INTEGER, "
      "$BONUS REAL DEFAULT 0,"
      "$IS_ACTIVE INTEGER DEFAULT 1)";

  static const AT_BONUS = 'ALTER TABLE $NAME ADD COLUMN $BONUS REAL DEFAULT 0';
  static const AT_STATE =
      'ALTER TABLE $NAME ADD COLUMN $IS_ACTIVE INTEGER DEFAULT 1';
}
