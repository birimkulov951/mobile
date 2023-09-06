class TNews {
  static const String NAME = 'news';

  static const ID = 'id';
  static const TITLE = 'title';
  static const MESSAGE = 'message';
  static const LOGO_URL = 'logo_url';
  static const DATE = 'date';
  static const ACTIVE = 'active';

  static const SQL = "CREATE TABLE $NAME($ID INTEGER, $TITLE TEXT, " +
      "$MESSAGE TEXT, $LOGO_URL TEXT, $DATE INTEGER, $ACTIVE INTEGER)";

  static const DROP = 'DROP TABLE IF EXISTS $NAME';
}
