class TPynetId {
  static const NAME = 'my_accounts';

  static const ID = 'id';
  static const UPDATE_TIME = 'update_time';
  static const ACCOUNT = 'account';
  static const COMMENT = 'comment';
  static const LAST_BALANCE = 'last_balance';
  static const BALANCE_TYPE = 'balance_type';
  static const ORDER = 'ord';
  static const MERCHANT_ID = 'merchant_id';
  static const MERCHANT_NAME = 'merchant_name';
  static const PAY_BILL = 'pay_bill';

  static const SQL =
      "CREATE TABLE $NAME($ID INTEGER, $UPDATE_TIME TEXT, $ACCOUNT TEXT, " +
          "$COMMENT TEXT, $LAST_BALANCE INTEGER, $BALANCE_TYPE INTEGER, $ORDER INTEGER, "
              "$MERCHANT_ID INTEGER, $MERCHANT_NAME TEXT, $PAY_BILL TEXT)";
}
