class TCategory {
  static const String NAME = 'category';

  static const ID = 'id';
  static const NAME_RU = 'name_ru';
  static const NAME_UZ = 'name_uz';
  static const NAME_EN = 'name_en';
  static const ORDER = 'display_order';

  static const SQL =
      "CREATE TABLE $NAME($ID INTEGER, $NAME_RU TEXT, $NAME_UZ TEXT, " +
          "$NAME_EN TEXT, $ORDER INTEGER)";
}
