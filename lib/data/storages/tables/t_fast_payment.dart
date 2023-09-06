class TFastPayment {
  static const NAME = 'fast_payments';

  static const MERCHANT_ID = 'merchant_id';
  static const MERCHANT_NAME = 'merchant_name';
  static const ACCOUNT = 'account';
  static const PAY_BILL = 'pay_bill';
  static const TITLE = 'title';

  static const SQL = "CREATE TABLE $NAME($ACCOUNT TEXT, " +
      "$TITLE TEXT, $MERCHANT_ID INTEGER, $MERCHANT_NAME TEXT, $PAY_BILL TEXT)";
}
