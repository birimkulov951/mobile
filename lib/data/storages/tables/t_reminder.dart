class TReminder {
  static const NAME = 'reminders';

  static const ID = 'id';
  static const CREATED_AT = 'create_date';
  static const LOGIN = 'login';
  static const MERCHANT_ID = 'merchant_id';
  static const ACCOUNT = 'account';
  static const REQUEST_STR = 'request_string';
  static const AMOUNT = 'amount';
  static const FIRE_WEEK_DAY = 'fire_week_day';
  static const FIRE_MONTH_DAY = 'fire_month_day';
  static const STATUS = 'status';
  static const TYPE = 'type';
  static const PAY_BILL = 'pay_bill';
  static const FINISH_DATE = 'finish_date';
  static const SINGLE = 'one_time_reminder';

  static const SQL =
      "CREATE TABLE $NAME($ID INTEGER, $CREATED_AT TEXT, $LOGIN TEXT, " +
          "$MERCHANT_ID TEXT, $ACCOUNT TEXT, $REQUEST_STR TEXT, $AMOUNT INTEGER, " +
          "$FIRE_WEEK_DAY INTEGER, $FIRE_MONTH_DAY INTEGER, $STATUS INTEGER, " +
          "$TYPE TEXT, $PAY_BILL TEXT, $FINISH_DATE TEXT, $SINGLE INTEGER)";
}
