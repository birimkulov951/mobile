class TCards {
  static const String NAME = 'cards';

  static const ID = 'id';
  static const TOKEN = 'token';
  static const XBTOKEN = 'xbtoken';
  static const CARD_NAME = 'card_name';
  static const MASKED_PAN = 'masked_pan';
  static const STATUS = 'status';
  static const PHONE = 'phone';
  static const BALANCE = 'balance';
  static const SMS = 'sms';
  static const ESTIMATED_LIMIT_IN = 'estimated_limit_in';
  static const ESTIMATED_LIMIT_OUT = 'estimated_limit_out';
  static const BANK_ID = 'bank_id';
  static const LOGIN = 'login';
  static const MAIN = 'main';
  static const COLOR_ID = 'color_id';
  static const EXPARE_DATE = 'expire_date';
  static const CREATED_DATE = 'created_date';
  static const ACTIVATED = 'activated';
  static const ORDER = 'display_order';
  static const ACTIVATED_DATE = 'activated_date';
  static const BANK_NAME = 'bank_name';
  static const TYPE = 'type';
  static const P2P_ENABLED = 'p2p_enabled';
  static const SUBSCRIBED = 'subscribed';
  static const SUBSCRIBE_LAST_DATE = 'subscribe_last_date';
  static const LIMIT_AMOUNT = 'limit_amount';
  static const LIMIT_LAST_DATE = 'limit_last_date';
  static const VALID = 'valid';
  static const MASKED_PHONE = 'masked_phone';
  static const HIDDEN_BALANCE = 'hidden_balance';

  static const SQL = "CREATE TABLE $NAME("
      "$ID INTEGER, "
      "$TOKEN TEXT, "
      "$XBTOKEN TEXT, "
      "$CARD_NAME TEXT, "
      "$MASKED_PAN TEXT, "
      "$STATUS TEXT, "
      "$PHONE TEXT, "
      "$BALANCE TEXT, "
      "$SMS INTEGER, "
      "$ESTIMATED_LIMIT_IN TEXT, "
      "$ESTIMATED_LIMIT_OUT TEXT, "
      "$BANK_ID TEXT, "
      "$LOGIN TEXT, "
      "$MAIN INTEGER, "
      "$COLOR_ID INTEGER, "
      "$EXPARE_DATE TEXT, "
      "$CREATED_DATE TEXT, "
      "$ACTIVATED TEXT, "
      "$ORDER INTEGER, "
      "$ACTIVATED_DATE TEXT, "
      "$BANK_NAME TEXT, "
      "$TYPE INTEGER, "
      "$P2P_ENABLED INTEGER, "
      "$SUBSCRIBED INTEGER, "
      "$SUBSCRIBE_LAST_DATE TEXT, "
      "$LIMIT_AMOUNT TEXT, "
      "$LIMIT_LAST_DATE TEXT, "
      "$VALID INTEGER, "
      "$HIDDEN_BALANCE INTEGER, "
      "$MASKED_PHONE TEXT)";
}
